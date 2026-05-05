const { danger, fail, message } = require("danger");
const { execSync } = require("node:child_process");
const fs = require("node:fs");

const MAX_WIDGET_FILE_LINES = 300;

const changedFiles = [...danger.git.created_files, ...danger.git.modified_files];
const changedDartFiles = changedFiles.filter((file) => file.endsWith(".dart"));

async function checkNoSetState() {
  const violations = [];

  for (const file of changedDartFiles) {
    const diff = await danger.git.structuredDiffForFile(file);
    if (!diff || !diff.chunks) {
      continue;
    }

    const hasSetStateOnAddedLine = diff.chunks.some((chunk) =>
      (chunk.changes || []).some(
        (change) =>
          change.type === "add" &&
          typeof change.content === "string" &&
          change.content.includes("setState("),
      ),
    );

    if (hasSetStateOnAddedLine) {
      violations.push(file);
    }
  }

  if (violations.length > 0) {
    fail(
      [
        "Found `setState(` in added lines (not allowed):",
        ...violations.map((file) => `- ${file}`),
        "Use Cubit/Bloc state updates instead.",
      ].join("\n"),
    );
  } else {
    message("No `setState(` usage found in added lines.");
  }
}

function checkAnalyzer() {
  try {
    const output = execSync("dart analyze --fatal-infos --fatal-warnings", {
      encoding: "utf8",
      stdio: ["ignore", "pipe", "pipe"],
    });
    if (output.trim().length > 0) {
      message("`dart analyze` passed.\n\n```txt\n" + output.slice(0, 4000) + "\n```");
    } else {
      message("`dart analyze` passed.");
    }
  } catch (error) {
    const stdout = error.stdout ? String(error.stdout) : "";
    const stderr = error.stderr ? String(error.stderr) : "";
    const combined = (stdout + "\n" + stderr).trim();
    fail(
      "Lint/analyzer failed. Fix all analyzer issues before merge.\n\n```txt\n" +
        combined.slice(0, 12000) +
        "\n```",
    );
  }
}

function checkWidgetFileLineLimit() {
  const widgetFiles = changedDartFiles.filter((file) =>
    file.includes("/presentation/widgets/"),
  );

  const oversized = [];

  for (const file of widgetFiles) {
    if (!fs.existsSync(file)) {
      continue;
    }

    const lineCount = fs.readFileSync(file, "utf8").split("\n").length;
    if (lineCount > MAX_WIDGET_FILE_LINES) {
      oversized.push({ file, lineCount });
    }
  }

  if (oversized.length > 0) {
    fail(
      [
        `Widget file line limit exceeded (max ${MAX_WIDGET_FILE_LINES} lines):`,
        ...oversized.map((item) => `- ${item.file} (${item.lineCount} lines)`),
      ].join("\n"),
    );
  } else {
    message(`All changed widget files are within ${MAX_WIDGET_FILE_LINES} lines.`);
  }
}

async function runChecks() {
  await checkNoSetState();
  checkAnalyzer();
  checkWidgetFileLineLimit();
}

runChecks();
