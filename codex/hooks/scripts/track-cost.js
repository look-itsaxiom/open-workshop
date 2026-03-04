#!/usr/bin/env node
// Open Workshop — SubagentStop Cost Tracker
// Parses teammate/subagent transcript JSONL, calculates token cost,
// appends to ~/.open-workshop/cost-log.jsonl for later reconciliation.
//
// Triggered by: SubagentStop (async, non-blocking)
// Input: Hook payload via stdin (JSON)
// Output: Appends cost entry to ~/.open-workshop/cost-log.jsonl

const fs = require('fs');
const path = require('path');
const readline = require('readline');
const os = require('os');

// Anthropic pricing per million tokens (USD)
const PRICING = {
  opus:   { input: 15.00, output: 75.00, cache_write: 18.75, cache_read: 1.50 },
  sonnet: { input: 3.00,  output: 15.00, cache_write: 3.75,  cache_read: 0.30 },
  haiku:  { input: 0.80,  output: 4.00,  cache_write: 1.00,  cache_read: 0.08 }
};

function getTier(modelId) {
  if (!modelId) return 'sonnet';
  const id = modelId.toLowerCase();
  if (id.includes('opus'))  return 'opus';
  if (id.includes('haiku')) return 'haiku';
  return 'sonnet';
}

function calculateCost(tokens, rates) {
  return (tokens.input * rates.input / 1_000_000)
       + (tokens.output * rates.output / 1_000_000)
       + (tokens.cache_creation * rates.cache_write / 1_000_000)
       + (tokens.cache_read * rates.cache_read / 1_000_000);
}

async function parseTranscript(filePath) {
  const tokens = { input: 0, output: 0, cache_creation: 0, cache_read: 0 };
  let model = null;
  let turnCount = 0;

  const rl = readline.createInterface({
    input: fs.createReadStream(filePath),
    crlfDelay: Infinity
  });

  for await (const line of rl) {
    if (!line.trim()) continue;
    try {
      const record = JSON.parse(line);
      if (record.type === 'assistant' && record.message?.usage) {
        const u = record.message.usage;
        tokens.input += u.input_tokens || 0;
        tokens.output += u.output_tokens || 0;
        tokens.cache_creation += u.cache_creation_input_tokens || 0;
        tokens.cache_read += u.cache_read_input_tokens || 0;
        turnCount++;
        if (!model && record.message.model) {
          model = record.message.model;
        }
      }
    } catch (e) {
      // Skip malformed lines
    }
  }

  return { tokens, model, turnCount };
}

async function main() {
  // Read hook payload from stdin
  let inputData = '';
  for await (const chunk of process.stdin) {
    inputData += chunk;
  }

  const payload = JSON.parse(inputData);

  // Determine transcript path
  const transcriptPath = payload.agent_transcript_path || payload.transcript_path;

  if (!transcriptPath || !fs.existsSync(transcriptPath)) {
    process.exit(0);
  }

  const { tokens, model, turnCount } = await parseTranscript(transcriptPath);

  if (turnCount === 0) {
    process.exit(0);
  }

  const tier = getTier(model);
  const rates = PRICING[tier];
  const cost = calculateCost(tokens, rates);

  const entry = {
    timestamp: new Date().toISOString(),
    hook_event: payload.hook_event_name,
    session_id: payload.session_id,
    teammate_name: payload.teammate_name || null,
    team_name: payload.team_name || null,
    agent_id: payload.agent_id || null,
    agent_type: payload.agent_type || null,
    model: model,
    model_tier: tier,
    turns: turnCount,
    tokens: tokens,
    estimated_cost_usd: Math.round(cost * 1_000_000) / 1_000_000,
    transcript_path: transcriptPath
  };

  // Write to user data directory, not plugin root
  const dataHome = path.join(os.homedir(), '.open-workshop');
  const costLogPath = path.join(dataHome, 'cost-log.jsonl');

  if (!fs.existsSync(dataHome)) {
    fs.mkdirSync(dataHome, { recursive: true });
  }

  fs.appendFileSync(costLogPath, JSON.stringify(entry) + '\n');

  process.exit(0);
}

main().catch(err => {
  process.stderr.write(`track-cost error: ${err.message}\n`);
  process.exit(1);
});
