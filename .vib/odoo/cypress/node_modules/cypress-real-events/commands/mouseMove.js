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
exports.realMouseMove = void 0;
const fireCdpCommand_1 = require("../fireCdpCommand");
const getCypressElementCoordinates_1 = require("../getCypressElementCoordinates");
/** @ignore this, update documentation for this function at index.d.ts */
function realMouseMove(subject, x, y, options = {}) {
    return __awaiter(this, void 0, void 0, function* () {
        const basePosition = (0, getCypressElementCoordinates_1.getCypressElementCoordinates)(subject, "topLeft", options.scrollBehavior);
        const log = Cypress.log({
            $el: subject,
            name: "realMouseMove",
            consoleProps: () => ({
                "Applied To": subject.get(0),
                "Absolute Element Coordinates": basePosition,
            }),
        });
        log.snapshot("before");
        yield (0, fireCdpCommand_1.fireCdpCommand)("Input.dispatchMouseEvent", {
            type: "mouseMoved",
            x: x + basePosition.x,
            y: y + basePosition.y,
        });
        log.snapshot("after").end();
        return subject;
    });
}
exports.realMouseMove = realMouseMove;
