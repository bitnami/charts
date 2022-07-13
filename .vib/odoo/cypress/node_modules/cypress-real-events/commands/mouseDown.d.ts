/// <reference types="cypress" />
/// <reference types="cypress" />
import { ScrollBehaviorOptions, Position } from "../getCypressElementCoordinates";
import { mouseButtonNumbers } from "../mouseButtonNumbers";
export interface realMouseDownOptions {
    /** Pointer type for realMouseDown, if "pen" touch simulated */
    pointer?: "mouse" | "pen";
    /**
     * Position of the realMouseDown event relative to the element
     * @example cy.realMouseDown({ position: "topLeft" })
     */
    position?: Position;
    /**
     * Controls how the page is scrolled to bring the subject into view, if needed.
     * @example cy.realMouseDown({ scrollBehavior: "top" });
     */
    scrollBehavior?: ScrollBehaviorOptions;
    /**
     * @default "left"
     */
    button?: keyof typeof mouseButtonNumbers;
}
/** @ignore this, update documentation for this function at index.d.ts */
export declare function realMouseDown(subject: JQuery, options?: realMouseDownOptions): Promise<JQuery<HTMLElement>>;
