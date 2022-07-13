/// <reference types="cypress" />
/// <reference types="cypress" />
import { Position, ScrollBehaviorOptions } from "../getCypressElementCoordinates";
export interface RealMouseMoveOptions {
    /**
     * Initial position for movement
     * @default "topLeft"
     * @example cy.realMouseMove({ position: "topRight" })
     */
    position?: Position;
    /**
     * Controls how the page is scrolled to bring the subject into view, if needed.
     * @example cy.realClick({ scrollBehavior: "top" });
     */
    scrollBehavior?: ScrollBehaviorOptions;
}
/** @ignore this, update documentation for this function at index.d.ts */
export declare function realMouseMove(subject: JQuery, x: number, y: number, options?: RealMouseMoveOptions): Promise<JQuery<HTMLElement>>;
