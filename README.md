# ToyAD.jl

![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg) [![build](https://github.com/doorisajar/ToyAD.jl/workflows/CI/badge.svg)](https://github.com/doorisajar/ToyAD.jl/actions?query=workflow%3ACI) [![codecov.io](http://codecov.io/github/doorisajar/ToyAD.jl/coverage.svg?branch=main)](http://codecov.io/github/doorisajar/ToyAD.jl?branch=main)

Prototype implementation of automatic differentiation for learning purposes while reading [Evaluating Derivatives: Principles & Techniques of Algorithmic Differentiation (2nd Edition)](https://www.google.com/books/edition/_/xoiiLaRxcbEC?hl=en). Starting with forward mode, and (if time permits) moving on to reverse mode. 

Currently working functionality is shown in the unit tests:
- Forward mode differentiation for scalar-valued functions utilizing a subset of operators
- Gradients for vector-valued functions
- Jacobians coming soon!

Built without LLM assistance; references linked where appropriate. 

<!-- Tidyverse lifecycle badges, see https://www.tidyverse.org/lifecycle/ Uncomment or delete as needed. -->

<!-- ![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg) -->
<!-- ![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg) -->
<!-- ![lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg) -->
<!-- ![lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg) -->
<!-- ![lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->


<!-- travis-ci.com badge, uncomment or delete as needed, depending on whether you are using that service. -->
<!-- [![Build Status](https://travis-ci.com/doorisajar/ToyAD.jl.svg?branch=main)](https://travis-ci.com/doorisajar/ToyAD.jl) -->
<!-- Coverage badge on codecov.io, which is used by default. -->

<!-- Documentation -- uncomment or delete as needed -->
<!-- [![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://doorisajar.github.io/ToyAD.jl/stable) -->
<!-- Aqua badge, see test/runtests.jl -->
<!-- [![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/main/badge.svg)](https://github.com/JuliaTesting/Aqua.jl) -->
