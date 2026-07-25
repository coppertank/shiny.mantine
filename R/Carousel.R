#' @include mantine-element.R
NULL

#' Mantine Carousel
#'
#' Requires `@mantine/carousel` + `embla-carousel-react` (already included
#' in the package's JS bundle).
#'
#' @rdname Carousel
#' @param ... Props and children ([CarouselSlide()]) for `Carousel()`;
#'   props for `CarouselSlide()`. See <https://mantine.dev/x/carousel/>.
#' @export
Carousel <- displayComponent("Carousel")

#' @rdname Carousel
#' @export
CarouselSlide <- displayComponent("Carousel.Slide")
