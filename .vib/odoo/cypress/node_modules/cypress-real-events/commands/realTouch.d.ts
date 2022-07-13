/// <reference types="cypress" />
/// <reference types="cypress" />
import { Position } from '../getCypressElementCoordinates';
export interface RealTouchOptions {
    /**
     * Position of the click event relative to the element
     * @example cy.realTouch({ position: "topLeft" })
     */
    position?: Position;
    /** X coordinate to click, relative to the Element. Overrides `position`.
     * @example
     * cy.get("canvas").realTouch({ x: 100, y: 115 })
     * cy.get("body").realTouch({ x: 11, y: 12 }) // global touch by coordinates
     */
    x?: number;
    /**  X coordinate to click, relative to the Element. Overrides `position`.
     * @example
     * cy.get("canvas").realTouch({ x: 100, y: 115 })
     * cy.get("body").realTouch({ x: 11, y: 12 }) // global touch by coordinates
     */
    y?: number;
    /**  radius of the touch area.
     * @example
     * cy.get("canvas").realTouch({ x: 100, y: 115, radius: 10 })
     * cy.get("body").realTouch({ x: 11, y: 12, radius: 10 }) // global touch by coordinates
     */
    radius?: number;
    /**  specific radius of the X axis of the touch area
     * @example
     * cy.get("canvas").realTouch({ x: 100, y: 115, radiusX: 10, radiusY: 20 })
     * cy.get("body").realTouch({ x: 11, y: 12, radiusX: 10, radiusY: 20 }) // global touch by coordinates
     */
    radiusX?: number;
    /**  specific radius of the Y axis of the touch area
     * @example
     * cy.get("canvas").realTouch({ x: 100, y: 115, radiusX: 10, radiusY: 20 })
     * cy.get("body").realTouch({ x: 11, y: 12, radiusX: 10, radiusY: 20 }) // global touch by coordinates
     */
    radiusY?: number;
}
export declare function realTouch(subject: JQuery, options?: RealTouchOptions): Promise<JQuery<HTMLElement>>;
