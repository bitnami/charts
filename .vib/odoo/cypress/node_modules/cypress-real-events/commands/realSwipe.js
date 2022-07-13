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
exports.realSwipe = void 0;
const fireCdpCommand_1 = require("../fireCdpCommand");
const getCypressElementCoordinates_1 = require("../getCypressElementCoordinates");
function forEachSwipePosition({ length, step, startPosition, direction, }, onStep) {
    return __awaiter(this, void 0, void 0, function* () {
        if (length < step) {
            throw new Error("cy.realSwipe: options.length can not be smaller than options.step");
        }
        const getPositionByDirection = {
            toTop: (step) => ({
                x: startPosition.x,
                y: startPosition.y - step,
            }),
            toBottom: (step) => ({
                x: startPosition.x,
                y: startPosition.y + step,
            }),
            toLeft: (step) => ({
                x: startPosition.x - step,
                y: startPosition.y,
            }),
            toRight: (step) => ({
                x: startPosition.x + step,
                y: startPosition.y,
            }),
        };
        for (let i = 0; i <= length; i += step) {
            yield onStep(getPositionByDirection[direction](i));
        }
    });
}
function realSwipe(subject, direction, options = {}) {
    var _a, _b;
    return __awaiter(this, void 0, void 0, function* () {
        const position = options.x && options.y
            ? { x: options.x, y: options.y }
            : options.touchPosition;
        const length = (_a = options.length) !== null && _a !== void 0 ? _a : 10;
        const step = (_b = options.step) !== null && _b !== void 0 ? _b : 10;
        const startPosition = (0, getCypressElementCoordinates_1.getCypressElementCoordinates)(subject, position);
        const log = Cypress.log({
            $el: subject,
            name: "realSwipe",
            consoleProps: () => ({
                "Applied To": subject.get(0),
                "Swipe Length": length,
                "Swipe Step": step,
            }),
        });
        log.snapshot("before");
        yield (0, fireCdpCommand_1.fireCdpCommand)("Input.dispatchTouchEvent", {
            type: "touchStart",
            touchPoints: [startPosition],
        });
        yield forEachSwipePosition({
            length,
            step,
            direction,
            startPosition,
        }, (position) => (0, fireCdpCommand_1.fireCdpCommand)("Input.dispatchTouchEvent", {
            type: "touchMove",
            touchPoints: [position],
        }));
        yield (0, fireCdpCommand_1.fireCdpCommand)("Input.dispatchTouchEvent", {
            type: "touchEnd",
            touchPoints: [],
        });
        log.snapshot("after").end();
        return subject;
    });
}
exports.realSwipe = realSwipe;
