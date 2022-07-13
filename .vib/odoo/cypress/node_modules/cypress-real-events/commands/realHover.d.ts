/// <reference types="cypress" />
/// <reference types="cypress" />
import { Position, ScrollBehaviorOptions } from "../getCypressElementCoordinates";
export interface RealHoverOptions {
    /**
     * If set to `pen`, simulates touch based hover (via long press)
     */
    pointer?: "mouse" | "pen";
    /**
     * Position relative to the element where to hover the element.
     * @example cy.realHover({ position: "topLeft" })
     */
    position?: Position;
    /**
     * Controls how the page is scrolled to bring the subject into view, if needed.
     * @example cy.realHover({ scrollBehavior: "top" });
     */
    scrollBehavior?: ScrollBehaviorOptions;
}
/** @ignore this, update documentation for this function at index.d.ts */
export declare function realHover(subject: JQuery, options?: RealHoverOptions): Promise<JQuery<HTMLElement>>;
