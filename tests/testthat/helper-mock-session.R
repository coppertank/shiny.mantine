mock_session <- function() {
  messages <- new.env(parent = emptyenv())
  messages$log <- list()
  list(
    ns = function(id) id,
    sendCustomMessage = function(type, message) {
      messages$log[[length(messages$log) + 1]] <- list(type = type, message = message)
    },
    .messages = messages
  )
}
