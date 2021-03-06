
#' @importFrom utils str
#' @export
"print.torch.Tensor" <- function(x, ...) {
    if (py_is_null_xptr(x))
        message("<pointer: 0x0>\n")
    else {
        str(x, ...)
        if (!is.null(torch$get_num_threads())) {
            value <- tryCatch(x$eval(), error = function(e) NULL)
            if (!is.null(value))
                message(" ", str(value), "\n", sep = "")
        }
    }
}


#' @export
py_str.torch.python.ops.variables.Variable <- function(object, ...) {
    paste0("Variable(shape=", py_str(object$size()), ", ",
           "dtype=", object$dtype$name, ")\n", sep = "")
}



#' @importFrom utils .DollarNames
#' @export
.DollarNames.torch.python.platform.flags._FlagValues <- function(x, pattern = "") {

    # skip if this is a NULL xptr
    if (py_is_null_xptr(x))
        return(character())

    # get the underlying flags and return the names
    flags <- x$`__flags`
    names(flags)
}


#' One tensor operation
#'
#' @param x tensor
#'
#' @examples
#' \dontrun{
#' A <- torch$ones(c(60000L, 1L, 28L, 28L))
#' dim(A)
#' }
one_tensor_op <- function(x) UseMethod("one_tensor_op")



#' Dimensions of a tensor
#'
#' Get the dimensions of a tensor displaying it as a vector.
#'
#' @param x tensor
#'
#' @return a vector of integers with the dimensions of the tensor
#' @export
#' @examples
#' \dontrun{
#' uo = torch$ones(3L, 5L)  # it is a 3x5 tensor
#' dim(uo)
#' }
#'
"dim.torch.Tensor" <- function(x) {        # change .tensor to .Tensor
    if (py_is_null_xptr(x))
        NULL
    else {
        shape <- import_builtins()$list(x$size())  # return a list
        # shape <- x$dim()   # torch has a dim() function
        if (!is.null(shape))
            shape
        else
            NULL
    }
}

#' Length of a tensor.
#'
#' This function is equivalent to torch$numel()
#'
#' @param x tensor
#'
#' @return the number of elements of a tensor as an integer
#' @export
#' @examples
#' \dontrun{
#' uo = torch$ones(3L, 5L)   # tensor with 15 elements
#' length(uo)
#' }
#'
"length.torch.Tensor" <- function(x) {
    if (py_is_null_xptr(x))
        length(NULL)
    else
        Reduce(`*`, dim(x))
}


#' Remainder
#'
#' Computes the element-wise remainder of division.
#' @param a a tensor
#' @param b a scalar or a tensor
#' @export
#' @examples
#' \dontrun{
#' x <- torch$Tensor(list(-3., -2, -1, 1, 2, 3))
#' y <- torch$Tensor(list(1., 2, 3, 4, 5))
#' torch$remainder(x, 2)
#' torch$remainder(y, 1.5)
#'
#' x %% 2
#' y %% 1.5
#' }
#' @return the reminder of the division between tensor by a scalar or tensor
"%%.torch.Tensor" <- function(a, b) {
    torch$remainder(a, b)
}



#' all
#'
#' Returns True if all elements in the tensor are non-zero, False otherwise.
#' @param x tensor
#' @param dim dimension to reduce
#' @param ... other parameters (yet to be developed)
#'
#' @return A tensor of type torch.uint8 representing the boolean result:
#' 1 for TRUE and 0 for FALSE.
#'
#' @export
#' @examples
#' \dontrun{
#' a <- torch$BoolTensor(list(TRUE, TRUE, TRUE, TRUE))
#' b <- torch$BoolTensor(list(FALSE, TRUE, TRUE, TRUE))
#' c <- torch$BoolTensor(list(TRUE, TRUE, TRUE, FALSE))
#' all(a)
#' all(b)
#' all(c)
#' d <- torch$tensor(list(list(0, 0),
#'                        list(0, 0),
#'                        list(0, 1),
#'                        list(1, 1)), dtype=torch$uint8)
#' all(d)
#' all(d, dim=0L)
#' all(d, dim=1L)
#' }
"all.torch.Tensor" <- function(x, dim, ...) {
    # quick version of torch$all
    # TODO: modify to use all arguments
    # all(dim, keepdim=False, out=None) → Tensor
    # DO NOT USE torch$tensor() to prevent warning:
    #            ... it is recommended to use sourceTensor.clone().detach()
    x <- torch$as_tensor(x, dtype = torch$uint8)
    # as.logical(torch$all(x)$numpy())
    if (missing(dim)) torch$all(x) else torch$all(x, dim=as.integer(dim))
}


#' any
#'
#' Returns True if any elements in the tensor are non-zero, False otherwise.
#' @param x tensor
#' @param dim dimension to reduce
#' @param ... other params (yet to be developed)
#'
#' @return A tensor of type torch.uint8 representing the boolean result:
#' 1 for TRUE and 0 for FALSE.
#'
#' @export
#' @examples
#' \dontrun{
#' a <- torch$BoolTensor(list(TRUE, TRUE, TRUE, TRUE))
#' b <- torch$BoolTensor(list(FALSE, TRUE, TRUE, TRUE))
#' c <- torch$BoolTensor(list(TRUE, TRUE, TRUE, FALSE))
#' any(a)
#' any(b)
#' any(c)
#' d <- torch$tensor(list(list(1, 0),
#'                        list(0, 0),
#'                        list(0, 1),
#'                        list(0, 0)), dtype=torch$uint8)
#' any(d)
#' any(d, dim=0L)
#' any(d, dim=1L)
#' }
"any.torch.Tensor" <- function(x, dim, ...) {
    # quick version of torch$any
    # TODO: modify to use all arguments
    # all(dim, keepdim=False, out=None) → Tensor
    # DO NOT USE torch$tensor() to prevent warning:
    #            ... it is recommended to use sourceTensor.clone().detach()
    x <- torch$as_tensor(x, dtype = torch$uint8)
    # as.logical(torch$any(x)$numpy())
    if (missing(dim)) torch$any(x) else torch$any(x, dim=as.integer(dim))
}


#' Two tensor operations
#'
#' @param a tensor
#' @param b tensor
#' @examples
#' \dontrun{
#' a <- torch$Tensor(list(1, 1, 1))
#' b <- torch$Tensor(list(2, 2, 2))
#' s <- 2.0
#' a + b
#' b - a
#' a * b
#' a / s
#' a == b
#' a == a
#' a != a
#' x <- torch$Tensor(list(list(2, 2, 2), list(4, 4, 4)))
#' y <- torch$Tensor(list(list(1, 2, 1), list(3, 4, 5)))
#' x > y
#' x < y
#' x >= y
#' y <= x
#' diag <- torch$eye(3L)
#' zeros <- torch$zeros(c(3L, 3L))
#' diag & zeros
#' diag & diag
#' diag | diag
#' zeros | zeros
#' zeros & zeros
#' diag & zeros
#' diag | zeros
#' }
tensor_ops <- function(a, b) UseMethod("tensor_ops")



#' Add two tensors
#'
#' This generic is similar to applying \code{torch$add(a, b)}
#'
#' @param a tensor
#' @param b tensor
#' @return Another tensor representing the addition of two tensors.
#'
#' @examples
#' \dontrun{
#' a <- torch$Tensor(list(1, 1, 1))
#' b <- torch$Tensor(list(2, 2, 2))
#' s <- 2.0
#' a + b
#' }
#' @export
"+.torch.Tensor" <- function(a, b) {
    if (any(class(a) == "torch.Tensor"))
        torch$add(a, b)
    else
        torch$add(b, a)
}


#' Subtract two tensors
#'
#' This generic is similar to applying \code{torch$sub(a, b)}
#'
#' @param a tensor
#' @param b tensor
#' @return Another tensor representing the subtraction of two tensors.
#'
#' @examples
#' \dontrun{
#' a <- torch$Tensor(list(1, 1, 1))
#' b <- torch$Tensor(list(2, 2, 2))
#' s <- 2.0
#' a - b
#' }
#'
#' @export
"-.torch.Tensor" <- function(a, b) {
    if (missing(b)) {
        if (py_has_attr(torch, "negative"))
            torch$negative(a)
        else
            torch$neg(a)
    } else {
        if (py_has_attr(torch, "subtract"))
            torch$subtract(a, b)
        else
            torch$sub(a, b)
    }
}


#' Tensor multiplication
#'
#' This generic is similar to \code{torch$mul(a, b)}
#'
#' @param a tensor
#' @param b tensor
#' @return Another tensor representing the multiplication of two tensors.
#'
#' @examples
#' \dontrun{
#' a <- torch$Tensor(list(1, 1, 1))
#' b <- torch$Tensor(list(2, 2, 2))
#' s <- 2.0
#' a * b
#' }
#'
#' @export
"*.torch.Tensor" <- function(a, b) {
    if (py_has_attr(torch, "multiply"))
        torch$multiply(a, b)
    else
        torch$mul(a, b)
}


#' Divide two tensors
#'
#' This generic is similar to \code{torch$div(a, b)}
#'
#' @param a tensor
#' @param b tensor
#' @return Another tensor representing the division of two tensors.
#'
#' @examples
#' \dontrun{
#' a <- torch$Tensor(list(1, 1, 1))
#' b <- torch$Tensor(list(2, 2, 2))
#' s <- 2.0
#' a / b
#' }
#' @export
"/.torch.Tensor" <- function(a, b) {
    torch$div(a, b)
}




#' Compares two tensors if equal
#'
#' This generic is approximately similar to \code{torch$eq(a, b)}, with the
#' difference that the generic returns a tensor of booleans instead of
#' a tensor of data type \code{torch$uint8}.
#'
#' @param x tensor
#' @param y tensor
#' @return A tensor of booleans, where False corresponds to 0, and 1 to True
#' in a tensor of data type \code{torch$bool}.
#'
#' @examples
#' \dontrun{
#' a <- torch$Tensor(list(1, 1, 1))
#' b <- torch$Tensor(list(2, 2, 2))
#' a == b
#' }
#'
#' @export
"==.torch.Tensor" <- function(x, y) {
    if (x$data$type() == "torch.BoolTensor" & y$data$type() == "torch.BoolTensor") {
        torch$as_tensor(torch$eq(x, y), dtype = torch$bool)
    } else {
        torch$eq(x, y)
    }
}


#' Compare two tensors if not equal
#'
#' This generic is approximately similar to \code{torch$ne(a, b)}, with the
#' difference that the generic returns a tensor of booleans instead of
#' a tensor of data type \code{torch$uint8}.
#'
#' @param x tensor
#' @param y tensor
#' @return A tensor of booleans, where False corresponds to 0, and 1 to True
#' in a tensor of data type \code{torch$bool}.
#'
#' @examples
#' \dontrun{
#' a <- torch$Tensor(list(1, 1, 1))
#' b <- torch$Tensor(list(2, 2, 2))
#' a != b
#' }
#' @export
#' @name not_equal_to
"!=.torch.Tensor" <- function(x, y) {
    # there is not not_equal function in PyTorch
    if (x$data$type() == "torch.BoolTensor" & y$data$type() == "torch.BoolTensor") {
        # if x and y are booleans then should return boolean
        torch$as_tensor(torch$ne(x, y), dtype = torch$bool)
    } else {
        torch$ne(x, y)
    }
}



#' Logical NOT of a tensor
#'
#' There is not equivalent function in PyTorch for this generic.
#' To generate This generic we use the function \code{np$logical_not(x)}.
#'
#' @param x tensor
#'
#' @return A tensor of booleans, where False corresponds to 0, and 1 to True
#' in a tensor of data type \code{torch$bool}.
#'
#' @examples
#' \dontrun{
#' A <- torch$ones(5L)
#' !A
#'
#' Z <- torch$zeros(5L)
#' !Z
#' }
#' @export
#' @name logical_not
"!.torch.Tensor" <- function(x) {
    # there is not logical NOT in PyTorch
    # torch$BoolTensor(np$logical_not(a))
    # torch$as_tensor(np$logical_not(x), dtype = torch$bool)
    if (x$data$type() == "torch.BoolTensor") {
        torch$as_tensor(np$logical_not(x), dtype = torch$bool)
    } else {
        torch$as_tensor(np$logical_not(x))
    }

}



#' Logical AND of two tensors
#'
#' There is not equivalent function in PyTorch for this generic.
#' To generate this generic we use the function \code{np$logical_and()}.
#'
#' @param x tensor
#' @param y tensor
#'
#' @return A tensor of booleans representing the logical result of the comparison.
#' False to represent 0, and True to represent 1 in a tensor of data type \code{torch$uint8}.
#'
#' @examples
#' \dontrun{
#' A <- torch$BoolTensor(list(0L, 1L))
#' B <- torch$BoolTensor(list(1L, 0L))
#' C <- torch$BoolTensor(list(1L, 1L))
#' A & B
#' C & A
#' B & C
#' }
#' @export
#' @name logical_and
"&.torch.Tensor" <- function(x, y) {
    # tensor_logical_and(a, b)
    if (x$data$type() == "torch.BoolTensor" & y$data$type() == "torch.BoolTensor") {
        torch$as_tensor(np$logical_and(x, y), dtype = torch$bool)
    } else {
        torch$as_tensor(np$logical_and(x, y))
    }
}


#' Logical OR of two tensors
#'
#' There is not equivalent function in PyTorch for this generic.
#' To generate this generic we use the function \code{np$logical_or()}.
#'
#' @param x tensor
#' @param y tensor
#'
#' @return A tensor of booleans representing the logical result of the comparison.
#' False to represent 0, and True to represent 1 in a tensor of data type \code{torch$uint8}.
#'
#' @examples
#' \dontrun{
#' A <- torch$BoolTensor(list(0L, 1L))
#' B <- torch$BoolTensor(list(1L, 0L))
#' C <- torch$BoolTensor(list(1L, 1L))
#' A | B
#' C | A
#' B | C
#' }
#' @export
#' @name logical_or
"|.torch.Tensor" <- function(x, y) {
    # tensor_logical_or(a, b)
    if (x$data$type() == "torch.BoolTensor" & y$data$type() == "torch.BoolTensor") {
        torch$as_tensor(np$logical_or(x, y), dtype = torch$bool)
    } else {
        torch$as_tensor(np$logical_or(x, y))
    }
}



#' Is a tensor less than another tensor
#'
#' This generic is similar to \code{torch$lt(a, b)}
#'
#' @param a tensor
#' @param b tensor
#'
#' @return A tensor of booleans representing the logical result of the comparison.
#' False to represent 0, and True to represent 1 in a tensor of data type \code{torch$uint8}.
#'
#' @examples
#' \dontrun{
#' A <- torch$ones(28L, 28L)
#' C <- A * 0.5
#' A < C
#'
#' }
#' @export
"<.torch.Tensor" <- function(a, b) {
    # torch$as_tensor(torch$lt(a, b), dtype = torch$bool)
    torch$lt(a, b)
}


#' Is a tensor less or equal than another tensor
#'
#' This generic is similar to \code{torch$le(a, b)}
#'
#' @param a tensor
#' @param b tensor
#'
#' @return A tensor of booleans representing the logical result of the comparison.
#' False to represent 0, and True to represent 1 in a tensor of data type \code{torch$uint8}.
#'
#' @examples
#' \dontrun{
#' A <- torch$ones(5L, 5L)
#' C <- torch$as_tensor(np$random$randint(2L, size=c(5L, 5L)), dtype=torch$float32)
#' A <= C
#' C <= A
#' }
#' @export
"<=.torch.Tensor" <- function(a, b) {
    # torch$as_tensor(torch$le(a, b), dtype = torch$bool)
    torch$le(a, b)
}


#' A tensor greater than another tensor
#'
#' This generic is similar to \code{torch$gt(a, b)}
#'
#' @param a tensor
#' @param b tensor
#'
#' @return A tensor of booleans representing the logical result of the comparison.
#' False to represent 0, and True to represent 1 in a tensor of data type \code{torch$uint8}.
#'
#' @examples
#' \dontrun{
#' A <- torch$ones(5L, 5L)
#' C <- torch$as_tensor(np$random$randint(2L, size=c(5L, 5L)), dtype=torch$float32)
#' A > C
#' C > A
#' }
#' @export
">.torch.Tensor" <- function(a, b) {
    # torch$gt(a, b)
    # torch$as_tensor(torch$gt(a, b), dtype = torch$bool)
    torch$gt(a, b)
}

#' Is a tensor greater or equal than another tensor
#'
#' This generic is similar to \code{torch$ge(a, b)}
#'
#' @param a tensor
#' @param b tensor
#'
#' @return A tensor of booleans representing the logical result of the comparison.
#' False to represent 0, and True to represent 1 in a tensor of data type \code{torch$uint8}.
#'
#' @examples
#' \dontrun{
#' A <- torch$ones(5L, 5L)
#' C <- torch$as_tensor(np$random$randint(2L, size=c(5L, 5L)), dtype=torch$float32)
#' A >= C
#' C >= A
#' }
#' @export
">=.torch.Tensor" <- function(a, b) {
    # torch$ge(a, b)
    # torch$as_tensor(torch$ge(a, b), dtype = torch$bool)
    torch$ge(a, b)
}


#' @export
"abs.torch.Tensor" <- function(x) {
    torch$abs(x)
}


#' @export
"sign.torch.Tensor" <- function(x) {
    torch$sign(x)
}


#' @export
"sqrt.torch.Tensor" <- function(x) {
    torch$sqrt(x)
}


#' @export
"floor.torch.Tensor" <- function(x) {
    torch$floor(x)
}


#' #' @export
#' "round.torch.Tensor" <- function(input) {
#'     # round: Returns a new tensor with each of the elements of input rounded to the closest integer.
#'     torch$round(input)
#' }


#' Dot product of two tensors
#'
#' This generic is similar to \code{torch$dot(a, b)}
#'
#' @param a tensor
#' @param b tensor
#'
#' @examples
#' \dontrun{
#' p <- torch$Tensor(list(2, 3))
#' q <- torch$Tensor(list(2, 1))
#' p %.*% q
#' }
#'
#' @return a scalar
#' @export
`%.*%` <- function(a, b) {
    torch$dot(a, b)
}


#' Matrix/Tensor multiplication of two tensors
#'
#' This generic is similar to \code{torch$matmul(a, b)}
#'
#' @param a tensor
#' @param b tensor
#'
#' @return a scalar or a tensor
#'
#' @examples
#' \dontrun{
#' p <- torch$randn(3L)
#' q <- torch$randn(3L)
#' p %**% q
#' }
#'
#' @export
`%**%` <- function(a, b) {
    torch$matmul(a, b)
}




#' @describeIn tensor_ops A tensor 'a' to the power of 'b'
#' @export
#' @examples
#' \dontrun{
#' x <- torch$arange(1,11)
#' torch$pow(x, 2)      #     x^(2)
#' torch$pow(x, -2)     #     x^(1/2)
#' }
#'
"^.torch.Tensor" <- function(a, b) {
    torch$pow(a, b)
}


#' @describeIn one_tensor_op Exponential of a tensor
#' @export
"exp.torch.Tensor" <- function(x) {
    torch$exp(x)
}


#' Logarithm of a tensor given the tensor and the base
#' @param x a tensor
#' @param base the base of the logarithm
#' @export
#' @examples
#' \dontrun{
#' x <- torch$tensor(c(512, 1024, 2048, 4096))   # tensor([ 9., 10., 11., 12.])
#' base <- 2
#' log(x, base)
#'
#' x <- torch$tensor(c(1, 10, 100, 1000))         # tensor([0., 1., 2., 3.])
#' log(x, 10)
#' }
"log.torch.Tensor" <- function(x, base = exp(1L)) {
    if (is_tensor(base) || base != exp(1L)) {
        # print("base IS a tensor")
        base <- torch$as_tensor(base, dtype=x$dtype)       # dtype mus be there
        torch$log(x) / torch$log(base)
    } else {
        # print("base is not a tensor")
        torch$log(x)
    }
}

#' Logarithm of a tensor in base 2
#' @param x a tensor
#' @export
#' @examples
#' \dontrun{
#' x <- torch$tensor(c(512, 1024, 2048, 4096))   # tensor([ 9., 10., 11., 12.])
#' }
#' @method log2 torch.Tensor
"log2.torch.Tensor" <- function(x) {
    torch$log2(x)
}


#' Logarithm of a tensor in base 10
#' @param x a tensor
#' @export
#' @examples
#' \dontrun{
#' x <- torch$tensor(c(1, 10, 100, 1000))     # tensor([0., 1., 2., 3.])
#' }
#' @method log10 torch.Tensor
"log10.torch.Tensor" <- function(x) {
    torch$log10(x)
}


#' @export
"sin.torch.Tensor" <- function(x) {
    torch$sin(x)
}

#' @export
"cos.torch.Tensor" <- function(x) {
    torch$cos(x)
}

#' @export
"tan.torch.Tensor" <- function(x) {
    torch$tan(x)
}


#' @export
"asin.torch.Tensor" <- function(x) {
    torch$asin(x)
}

#' @export
"acos.torch.Tensor" <- function(x) {
    torch$acos(x)
}


#' @export
"atan.torch.Tensor" <- function(x) {
    torch$atan(x)
}
