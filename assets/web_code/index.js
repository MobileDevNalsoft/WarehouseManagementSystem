import * as THREE from "three";
import { createRenderer } from "./renderer";
import { initScene } from "./sceneSetup";

let container, camera, scene, renderer;

document.addEventListener("DOMContentLoaded", function () {
    container = document.getElementById("container");
    // creating a container section(division) on our html page(not yet visible).
    container.id = "container";
    document.body.appendChild(container);
    // assigning div to document's visible structure i.e. body.

    renderer = createRenderer();

    scene = initScene(container, renderer);
});