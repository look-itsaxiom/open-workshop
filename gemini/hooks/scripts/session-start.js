#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const os = require('os');

const DATA_HOME = path.join(os.homedir(), '.open-workshop');
const CONFIG = path.join(DATA_HOME, 'config.yaml');
const MANIFEST = path.join(DATA_HOME, 'projects', '_manifest.yaml');

function getWorkshopName(configContent) {
  if (!configContent) return 'Open Workshop';
  const match = configContent.match(/workshop_name:\s*["']?([^"'\n]+)["']?/);
  return match ? match[1] : 'Open Workshop';
}

function getActiveProjects(manifestContent) {
  if (!manifestContent) return [];
  const projects = [];
  let inActive = false;
  const lines = manifestContent.split('\n');
  for (const line of lines) {
    if (line.startsWith('active:')) {
      inActive = true;
      continue;
    }
    if (line.match(/^[a-z]/) && inActive) {
      inActive = false;
      continue;
    }
    if (inActive) {
      const match = line.match(/^\s*-\s*([^\s]+)/);
      if (match) projects.push(match[1]);
    }
  }
  return projects;
}

function main() {
  let additionalContext = '';

  if (!fs.existsSync(CONFIG)) {
    additionalContext = `This is the user's first time using Open Workshop. The plugin data directory (~/.open-workshop/) has not been created yet.

**REQUIRED:** Invoke the setup-wizard skill to guide the user through first-run setup. Do not show the dashboard — there is nothing to show yet.

After setup completes, show the empty dashboard and prompt the user to onboard or create their first project.`;
  } else {
    const configContent = fs.readFileSync(CONFIG, 'utf8');
    const workshopName = getWorkshopName(configContent);
    const manifestContent = fs.existsSync(MANIFEST) ? fs.readFileSync(MANIFEST, 'utf8') : '';
    const activeProjects = getActiveProjects(manifestContent);

    additionalContext = `You are the ${workshopName} lead. Use the workshop-dashboard skill to present the project dashboard to the user.

Open Workshop data home: ${DATA_HOME}

=== WORKSHOP CONFIG ===
${configContent}

=== PROJECT MANIFEST ===
${manifestContent}
`;

    for (const project of activeProjects) {
      const statusFile = path.join(DATA_HOME, 'projects', project, 'status.md');
      const ledgerFile = path.join(DATA_HOME, 'projects', project, 'ledger.yaml');

      if (fs.existsSync(statusFile)) {
        additionalContext += `\n=== STATUS: ${project} ===\n${fs.readFileSync(statusFile, 'utf8')}\n`;
      }
      if (fs.existsSync(ledgerFile)) {
        const ledgerContent = fs.readFileSync(ledgerFile, 'utf8');
        const summaryMatch = ledgerContent.match(/summary:[\s\S]+/);
        if (summaryMatch) {
          additionalContext += `\n=== LEDGER SUMMARY: ${project} ===\n${summaryMatch[0]}\n`;
        }
      }
    }
  }

  process.stdout.write(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: 'SessionStart',
      additionalContext: additionalContext
    }
  }));
}

main();
