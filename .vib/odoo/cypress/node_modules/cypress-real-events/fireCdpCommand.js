"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.fireCdpCommand = void 0;
function fireCdpCommand(command, params) {
    return __awaiter(this, void 0, void 0, function* () {
        return Cypress.automation("remote:debugger:protocol", {
            command,
            params,
        }).catch((e) => {
            throw new Error(`Failed request to chrome devtools protocol. This can happen if cypress lost connection to the browser or the command itself is not valid. Original cypress error: ${e}`);
        });
    });
}
exports.fireCdpCommand = fireCdpCommand;
