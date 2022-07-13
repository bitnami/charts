/// <reference types="cypress" />
/// <reference types="cypress" />
import { ScrollBehaviorOptions, Position } from "../getCypressElementCoordinates";
export interface RealClickOptions {
    /** Pointer type for realClick, if "pen" touch simulated */
    pointer?: "mouse" | "pen";
    /** The button on mouse that clicked. Simulates real browser behavior. */
    button?: "none" | "left" | "right" | "middle" | "back" | "forward";
    /**
     * Position of the click event relative to the element
     * @example cy.realClick({ position: "topLeft" })
     */
    position?: Position;
    /** X coordinate to click, relative to the Element. Overrides `position`.
     * @example
     * cy.get("canvas").realClick({ x: 100, y: 115 })
     * cy.get("body").realClick({ x: 11, y: 12 }) // global click by coordinates
     */
    x?: number;
    /**  X coordinate to click, relative to the Element. Overrides `position`.
     * @example
     * cy.get("canvas").realClick({ x: 100, y: 115 })
     * cy.get("body").realClick({ x: 11, y: 12 }) // global click by coordinates
     */
    y?: number;
    /**
     * Controls how the page is scrolled to bring the subject into view, if needed.
     * @example cy.realClick({ scrollBehavior: "top" });
     */
    scrollBehavior?: ScrollBehaviorOptions;
    /**
     * Controls how many times pointer gets clicked. It can be used to simulate double clicks.
     * @example cy.realClick({ clickCount: 2 });
     */
    clickCount?: number;
}
/** @ignore this, update documentation for this function at index.d.ts */
export declare function realClick(subject: JQuery, options?: RealClickOptions): Promise<JQuery<HTMLElement>>;
