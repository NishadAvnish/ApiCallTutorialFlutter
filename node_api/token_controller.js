import jwt, { decode } from "jsonwebtoken"
import asyncHandler from "./response/asyncHandler.js";
import { BadRequestException, TokenExpirationException } from "./response/apiError.js";
import { ApiResponse } from "./response/response.js";
import { privateSecretKey } from "./constants/app.constant.js";


const createToken = ({ payload, expiryTime }) => {
    const token = jwt.sign(payload, privateSecretKey, { expiresIn: expiryTime != null ? expiryTime * 10 * 60 : null })
    return token;
}

const tokenAuthentication = asyncHandler(async (req, res, next) => {

    const token = req?.headers?.authorization;

    if (!token) {
        return next(new BadRequestException("Jwt Token Required!"))
    }
    const decodedPassword = jwt.verify(token, privateSecretKey, (error, user) => {
        if (error?.name === "TokenExpiredError") {
            return next(new TokenExpirationException());
        }
    });
    next();
})



const createTokenUsingRefreshToken = asyncHandler((req, res, next) => {
    const token = req.body.refreshToken;
    const email = req.body.email;

    if (!token) {
        next(new BadRequestException("Jwt Token Required!"))
    }

    console.log(token);
    let decodedUser;
    jwt.verify(token, privateSecretKey, (error, user) => {
        if (error) {
            if (error.name === "TokenExpiredError") {
                next(new TokenExpirationException());
            } else {
                next(new BadRequestException(error.message));
            }
        }
        decodedUser = user;
    });

    if (decodedUser.email != email) {
        next(new BadRequestException("Wrong Email address"))
    }

    const refreshToken = createToken({ payload: { email: email }, expiryTime: 24 })
    const accessToken = createToken({ payload: { email: email }, expiryTime: 1 })



    console.log(refreshToken);
    console.log(accessToken);
    res.status(200).send(new ApiResponse({
        status: 200, message: "Token generated!",
        data: { ...{ email }, accessToken, refreshToken },
    }))




})

export { createToken, tokenAuthentication, createTokenUsingRefreshToken };