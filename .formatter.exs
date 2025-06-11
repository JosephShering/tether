# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  without_parens: [middleware: 1],
  locals_without_parens: [
    t: 0,
    env: 0,
    resource: 2,
    resource: 3,
    scope: 3,
    get: 1,
    post: 1,
    put: 1,
    patch: 1,
    delete: 1,
    get: 2,
    post: 2,
    put: 2,
    patch: 2,
    delete: 2,
    request: 1,
    response: 1,
    request: 2,
    response: 2
  ]
]
