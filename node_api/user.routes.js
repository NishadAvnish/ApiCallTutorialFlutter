import { Router } from "express";
import { loginUser } from "./user.controller.js";

const router = Router();

router.route("/login").post(loginUser);


export default router;