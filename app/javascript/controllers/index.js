// app/javascript/controllers/index.js

import { application } from "controllers/application"

// "controllers/ファイル名" という形式でインポート
import NotebookFlipController from "controllers/notebook_flip_controller"
import HelloController from "controllers/hello_controller"

// 手動で登録（HTMLの data-controller="notebook-flip" と紐付ける）
application.register("notebook-flip", NotebookFlipController)
application.register("hello", HelloController)