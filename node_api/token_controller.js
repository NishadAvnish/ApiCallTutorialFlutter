import jwt, { decode } from "jsonwebtoken"
import asyncHandler from "./response/asyncHandler.js";
import { BadRequestException, TokenExpirationException } from "./response/apiError.js";
import { ApiResponse } from "./response/response.js";


const createToken = ({ payload, expiryTime }) => {
    const token = jwt.sign(payload, process.env.JWT_KEY, { expiresIn: expiryTime != null ? expiryTime * 10 * 60 : null })
    return token;
}

const tokenAuthentication = asyncHandler(async (req, res, next) => {
    const token = req.body.accessToken || req.query.params.accessToken;
    if (!token) {
        next(new BadRequestException("Jwt Token Required!"))
    }
    const decodedPassword = jwt.verify(token, process.env.JWT_KEY, (error, user) => {
        if (error.name === "TokenExpiredError") {
            next(new TokenExpirationException());
        } else {
            next(new BadRequestException(error.message));
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
    jwt.verify(token, process.env.JWT_KEY, (error, user) => {
        if (error) {
            if (error.name === "TokenExpiredError") {
                next(new TokenExpirationException());
            } else {
                next(new BadRequestException(error.message));
            }
        }
        decodedUser = user;
    });



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