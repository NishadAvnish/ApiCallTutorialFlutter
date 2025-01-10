import express from 'express';
import userRoutes from './user.routes.js';
import { tokenAuthentication, createTokenUsingRefreshToken } from './token_controller.js';
import { ApiResponse } from './response/response.js';
import { AppStrings } from './constants/app.strings.js';
import { ApiError, NotFoundException } from './response/apiError.js';
const app = express();
app.use(express.json());

app.use(express.json({ limit: "16kb" }))
app.use(express.urlencoded({ extended: true, limit: "16kb" }))


let products = [
    { id: 1, name: 'Product 1', price: 100, imageUrl: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" },
    { id: 2, name: 'Product 2', price: 200, imageUrl: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" },
];

// routes
app.use("/api/users", userRoutes);
app.use("/api/generateToken", createTokenUsingRefreshToken);

app.use(tokenAuthentication);


// Get list of products
app.get('/api/products', (req, res) => {

    res.status(200).send(new ApiResponse({ status: 200, message: AppStrings.successful, data: products }))
});

// Post a product
app.post('/api/product', (req, res) => {
    const { name, price, imageUrl } = req.body;
    if (!name || !price) {
        return res.status(403).json({
            status: 403,
            message: 'Error',
            data: 'Name and price are required'
        });
    }
    let imageUrl1 = imageUrl;
    if (!imageUrl) {
        imageUrl1 = "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    }
    const newProduct = { id: products.length + 1, name, price, imageUrl: imageUrl1 };
    products.push(newProduct);
    console.log(products.length);
    res.status(200).send(new ApiResponse({
        status: 200,
        message: 'Success',
        data: newProduct
    }))
});

// Update a product
app.put('/api/product', (req, res) => {
    const { id } = req.query;
    const { name, price, imageUrl } = req.body;
    const product = products.find(p => p.id === parseInt(id));

    if (!product) {
        return res.status(404).json({
            status: 404,
            message: 'Product not found',
            data: null
        });
    }

    if (name) product.name = name;
    if (price) product.price = price;
    if (imageUrl) product.imageUrl = imageUrl;

    res.status(200).send(new ApiResponse({
        status: 200,
        message: 'Success',
        data: product
    }))
});

// Delete a product
app.delete('/api/product', (req, res) => {
    const { id } = req.query;
    console.log(`id --> ${id}`)
    const productIndex = products.findIndex(p => p.id === parseInt(id));

    if (productIndex === -1) {
        return res.status(404).json({
            status: 404,
            message: 'Product not found',
            data: null
        });
    }

    const deletedProduct = products.splice(productIndex, 1);

    res.status(200).send(new ApiResponse({
        status: 200,
        message: 'Success',
        data: deletedProduct[0]
    }))

});



//error 
// error handling
app.all("*", (req, res, next) => {
    console.log(req.url);
    next(new NotFoundException({ message: `${req.url} not found on server` }));
})

app.use((error, req, res, next) => {
    if (error instanceof ApiError) {
        res.status(error.statusCode || 500)
            .send(new ApiResponse({ status: error.statusCode, message: error.message, data: error.data }))
    } else {
        res.status(error.statusCode || 500)
            .send(new ApiResponse({ status: error.statusCode, message: error.message, data: error.data }))
    }
})


const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
