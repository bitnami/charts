/// <reference types="cypress" />
/// <reference types="cypress" />
export declare type Position = "topLeft" | "top" | "topRight" | "left" | "center" | "right" | "bottomLeft" | "bottom" | "bottomRight" | {
    x: number;
    y: number;
};
declare type ScrollBehaviorPosition = "center" | "top" | "bottom" | "nearest";
export declare type ScrollBehaviorOptions = ScrollBehaviorPosition | false;
/**
 * Cypress Automation debugee is the whole tab.
 * This function returns the element coordinates relative to the whole tab root that can be used in CDP request.
 * @param jqueryEl the element to introspect
 */
export declare function getCypressElementCoordinates(jqueryEl: JQuery, position: Position | undefined, scrollBehavior?: ScrollBehaviorOptions): {
    x: number;
    y: number;
};
export {};
