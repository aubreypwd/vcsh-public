"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
function activate(ctx) {
    // create a new status bar item that we can now manage
    const barItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, -100);
    barItem.command = 'workbench.action.togglePanel';
    barItem.text = '$(layout-panel) Panel';
    barItem.show();
    ctx.subscriptions.push(barItem);
}
exports.activate = activate;
// This method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map