// app/javascript/controllers/index.js

import { application } from "./application"

import NotebookFlipController from "./notebook_flip_controller"
import HelloController from "./hello_controller"

application.register("notebook-flip", NotebookFlipController)
application.register("hello", HelloController)