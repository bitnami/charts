"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const realClick_1 = require("./commands/realClick");
const realHover_1 = require("./commands/realHover");
const realSwipe_1 = require("./commands/realSwipe");
const realPress_1 = require("./commands/realPress");
const realType_1 = require("./commands/realType");
const realTouch_1 = require("./commands/realTouch");
const mouseDown_1 = require("./commands/mouseDown");
const mouseUp_1 = require("./commands/mouseUp");
const mouseMove_1 = require("./commands/mouseMove");
// TODO fix this unsafe convertions. This happens because cypress does not allow anymore to return Promise for types, but allows for command which is pretty useful for current implementation.
Cypress.Commands.add("realClick", { prevSubject: true }, realClick_1.realClick);
Cypress.Commands.add("realHover", { prevSubject: true }, realHover_1.realHover);
Cypress.Commands.add("realTouch", { prevSubject: true }, realTouch_1.realTouch);
Cypress.Commands.add("realSwipe", { prevSubject: true }, realSwipe_1.realSwipe);
Cypress.Commands.add("realPress", realPress_1.realPress);
Cypress.Commands.add("realType", realType_1.realType);
Cypress.Commands.add("realMouseDown", { prevSubject: true }, mouseDown_1.realMouseDown);
Cypress.Commands.add("realMouseUp", { prevSubject: true }, mouseUp_1.realMouseUp);
Cypress.Commands.add("realMouseMove", 
// @ts-expect-error HOW is it possible?!
{ prevSubject: true }, mouseMove_1.realMouseMove);
