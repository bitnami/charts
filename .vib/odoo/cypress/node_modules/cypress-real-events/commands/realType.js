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
exports.realType = void 0;
const keyCodeDefinitions_1 = require("../keyCodeDefinitions");
const realPress_1 = require("./realPress");
const availableChars = Object.keys(keyCodeDefinitions_1.keyCodeDefinitions);
function assertChar(char) {
    if (!availableChars.includes(char)) {
        throw new Error(`Unrecognized character "${char}".`);
    }
}
/** @ignore this, update documentation for this function at index.d.ts */
function realType(text, options = {}) {
    var _a, _b;
    return __awaiter(this, void 0, void 0, function* () {
        let log;
        if ((_a = options.log) !== null && _a !== void 0 ? _a : true) {
            log = Cypress.log({
                name: "realType",
                consoleProps: () => ({
                    Text: text,
                }),
            });
        }
        log === null || log === void 0 ? void 0 : log.snapshot("before").end();
        const chars = text
            .split(/({.+?})/)
            .filter(Boolean)
            .reduce((acc, group) => {
            return /({.+?})/.test(group)
                ? [...acc, group]
                : [...acc, ...group.split("")];
        }, []);
        for (const char of chars) {
            assertChar(char);
            yield (0, realPress_1.realPress)(char, {
                pressDelay: (_b = options.pressDelay) !== null && _b !== void 0 ? _b : 15,
                log: false,
            });
            yield new Promise((res) => { var _a; return setTimeout(res, (_a = options.delay) !== null && _a !== void 0 ? _a : 25); });
        }
        log === null || log === void 0 ? void 0 : log.snapshot("after").end();
    });
}
exports.realType = realType;
