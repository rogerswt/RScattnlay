#' @import Rcpp
NULL

#' @title An S4 class to represent a layer around a nanoparticle
#'
#' @slot m the complex refractive index
#' @slot r the radius in nanometers
#' @export
Layer <- setClass("Layer",
                  slots=c(
                    m="complex",
                    r="numeric"
                    ))

#' @title An S4 class to represent a scattering simulation
#'
#' @slot na the real refractive index of the ambient or surrounding media
#' @slot lambda the wavelength of light in nanometers
#' @slot nt the number of theta angles
#' @slot ti the starting angle in degrees
#' @slot tf the end angle in degrees
#' @slot layers a list of layers of type Layer
#' @export
Scatterer <- setClass("Scatterer",
               slots=c(
                 na="numeric",
                 lambda="numeric",
                 nt="numeric",
                 ti="numeric",
                 tf="numeric",
                 layers="list"),
               prototype=list(
                 na = 1.0,
                 lambda = 500,
                 nt=0,
                 ti=0.0,
                 tf=90.0
               ),
               validity = function(object) {
                  if(object@nt < 0){
                    return("Negative value given for the number of theta angles")
                  } 
                 return(TRUE)
                }
               )

setMethod("show", signature(object="Layer"),function(object){
  cat("Layer Data \n")
  cat("Diameter:", 2*object@r," nm\n")
  cat("Complex Index:", object@m,"\n")
})

setMethod("show", signature(object="Scatterer"),function(object){
  cat("Scatterer Data \n")
  cat("Lambda:", object@lambda," nm\n")
  cat("Ambient Index", object@na, "\n")
})

setGeneric("na<-",function(x,value) standardGeneric("na<-"))
setGeneric("lambda<-",function(x,value) standardGeneric("lambda<-"))
setGeneric("nt<-",function(x,value) standardGeneric("nt<-"))
setGeneric("ti<-",function(x,value) standardGeneric("ti<-"))
setGeneric("tf<-",function(x,value) standardGeneric("tf<-"))
setGeneric("r<-",function(x,value) standardGeneric("r<-"))
setGeneric("m<-",function(x,value) standardGeneric("m<-"))


setMethod("na<-","Scatterer", function(x,value) {x@na <- value; validObject(x); x})
setMethod("lambda<-","Scatterer", function(x,value) {x@lambda <- value; validObject(x); x})
setMethod("nt<-","Scatterer", function(x,value) {x@nt <- value; validObject(x); x})
setMethod("ti<-","Scatterer", function(x,value) {x@ti <- value; validObject(x); x})
setMethod("tf<-","Scatterer", function(x,value) {x@tf <- value; validObject(x); x})
setMethod("r<-","Layer", function(x,value) {x@r <- value; validObject(x); x})
setMethod("m<-","Layer", function(x,value) {x@m <- value; validObject(x); x})

setGeneric("scattnlay", function(object) {standardGeneric("scattnlay")})

#' Method amplitudes.
#' @name amplitudes
#' @rdname amplitudes-methods
#' @exportMethod amplitudes
setGeneric("amplitudes", function(object) {standardGeneric("amplitudes")})

setMethod("scattnlay",signature(object="Scatterer"),function(object){
  Rpp<-S4_SCATTNLAY(object)
  return(Rpp)
})

#' @rdname amplitudes-methods
#' @aliases amplitudes,ANY-method
setMethod("amplitudes",signature(object="Scatterer"),function(object){
  S<-S4_AMPL(object)
  return(S)
})

setMethod("+", signature(e1="Scatterer",e2="Layer"), function(e1,e2){
  e1@layers <- c(e1@layers,e2)
  structure(e1,class="Scatterer")
})

