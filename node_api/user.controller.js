
import bcrypt from "bcrypt";
import asyncHandler from "./response/asyncHandler.js";
import { BadRequestException, NotFoundException, UnauthorizationException, UniversalApiError } from "./response/apiError.js";
import { AppStrings } from "./constants/app.strings.js";
import { ApiResponse } from "./response/response.js";
import { createToken } from "./token_controller.js";


const loginUser = asyncHandler(async (req, res, next) => {

      // take email and password from user
      // validate
      // check if email is exist or not
      // check if given password is correct or not
      // create refresh Token  with 10 days expiry
      // create accessToken with 1 day expiry

      const { email, password } = req.body;
      if (!email || !password || email?.trim() === "" || password === "") {
            return next(new BadRequestException(AppStrings.allParamsRequired));
      }

      const refreshToken = createToken({ payload: { email: email }, expiryTime: 24 })
      const accessToken = createToken({ payload: { email: email }, expiryTime: 1 })


      res.status(200).send(new ApiResponse({
            status: 200, message: "User Logined successfully!",
            data: { ...{ email: email }, refreshToken, accessToken },
      },
      ));

})





export { loginUser }