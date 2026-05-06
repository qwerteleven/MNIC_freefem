# mnic_freefem — FreeFEM++ PDE Simulation Collection

A collection of [FreeFEM++](https://freefem.org/) scripts solving a wide range of engineering [Partial Differential Equations (PDEs)](https://en.wikipedia.org/wiki/Partial_differential_equation) — from stationary heat conduction to incompressible Navier-Stokes flow around airfoils. The exercises progress from simple 2D diffusion problems to advanced fluid dynamics simulations.

---

## Overview

All scripts are written in the [FreeFEM scripting language](https://doc.freefem.org/) (`.edp` files) and make use of the [Finite Element Method (FEM)](https://en.wikipedia.org/wiki/Finite_element_method) to discretize and solve PDEs on 2D domains. The collection is organized thematically by increasing physical complexity.

---

## Project Structure

```
elfree/
├── ejercicio_2_EDP_evolutivo.edp           # Transient heat conduction, two materials
├── ejercicio_EDP_2_estacionario.edp        # Stationary heat conduction, two materials
├── problema_conveccion_y_difusion.edp      # Convection-diffusion with point sources
├── 6 conveccion difusion reaccion/         # Convection-diffusion-reaction problems
├── 7 modelizacion fuente puntual/          # Point source modeling
├── 8 ejercicios de adaptacion de mallas/   # Adaptive mesh refinement
├── 9 VARIOS MATERIALES O SUBDOMINIOS/      # Multi-material / subdomain problems
├── 10 CASO SOLO FLUJOS EN CONTORNO/        # Boundary flux problems (no Dirichlet)
├── 11 Problemas evolutivo y no lineales/   # Nonlinear transient temperature
└── 12 NAVIER STOKES FLUJO INCOMPRESIBLE/   # Incompressible Navier-Stokes flows
    └── variacion viento en altura/         # Wind profile + MATLAB utilities
```

---

## Topics Covered

### 1. Stationary Heat Conduction — `ejercicio_EDP_2_estacionario.edp`

Solves the [steady-state heat equation](https://en.wikipedia.org/wiki/Heat_equation) over a 2D domain composed of two materials (copper and aluminium) with mixed boundary conditions:

- [Convection boundary conditions](https://en.wikipedia.org/wiki/Convective_heat_transfer) on exposed surfaces
- Distinct [thermal conductivities](https://en.wikipedia.org/wiki/Thermal_conductivity): copper (380 W/m·K) and aluminium (237 W/m·K)
- Material regions identified via `region` labeling
- Solved using the [weak formulation](https://en.wikipedia.org/wiki/Weak_formulation) with P1 finite elements

### 2. Transient Heat Conduction — `ejercicio_2_EDP_evolutivo.edp`

Evolves the same copper-aluminium domain in time using an [implicit Euler](https://en.wikipedia.org/wiki/Backward_Euler_method) time-stepping scheme, running until a convergence criterion (point temperature difference < tolerance) is met. Outputs the heat flux vector field `(qx, qy) = -k∇u`.

### 3. Convection-Diffusion Problems — `6 conveccion difusion reaccion/`

Implements the [convection-diffusion-reaction equation](https://en.wikipedia.org/wiki/Convection%E2%80%93diffusion_equation):

```
∂T/∂t + u·∇T - k·ΔT + r·T = f
```

Two formulations are compared side by side:
- **Option A** — partial time derivative using [Euler's method](https://en.wikipedia.org/wiki/Euler_method)
- **Option B** — [material/total derivative](https://en.wikipedia.org/wiki/Material_derivative) using `convect()` (method of characteristics)

Also includes a **point source (spill) problem**: a pollutant discharged instantaneously at a point, modeled on an infinitesimal circular mesh, then transported by the flow field.

### 4. Point Source Modeling — `7 modelizacion fuente puntual/`

Models localized [point sources](https://en.wikipedia.org/wiki/Point_source) (heat or contamination) as Gaussian distributions on infinitesimally small circular sub-meshes, then integrates their contribution into the global domain via the integral formulation. Supports multiple simultaneous sources.

Also contains a **pure convection** demo using `convect()` to advect a Gaussian plume along a circular velocity field — illustrating the [method of characteristics](https://en.wikipedia.org/wiki/Method_of_characteristics).

### 5. Adaptive Mesh Refinement — `8 ejercicios de adaptacion de mallas/`

Uses `adaptmesh()` to iteratively refine the triangulation where the solution gradient is large, enabling efficient resolution of problems with [singularities](https://en.wikipedia.org/wiki/Singularity_(mathematics)). Key parameters:

| Parameter | Description |
|-----------|-------------|
| `err`     | Maximum element error |
| `hmax`    | Maximum triangle size |
| `hmin`    | Minimum triangle size |
| `nbvx`    | Maximum number of mesh vertices |
| `anisomax`| Anisotropy limit |

Benchmarks test conduction-convection with a strong singularity at a boundary point.

### 6. Multi-Material / Subdomain Problems — `9 VARIOS MATERIALES O SUBDOMINIOS/`

Solves thermal problems over domains composed of distinct materials (e.g. a refrigerator door made of glass and cork), where each subdomain has its own [thermal conductivity](https://en.wikipedia.org/wiki/Thermal_conductivity). Regions are identified using the FreeFEM `region` function and conductivity is assigned per-subdomain. Demonstrates that 2D FEM results match 1D analytical predictions under appropriate boundary conditions.

### 7. Boundary-Only Flux Problems — `10 CASO SOLO FLUJOS EN CONTORNO/`

Formulates conduction-convection problems using only [Neumann (flux) boundary conditions](https://en.wikipedia.org/wiki/Neumann_boundary_condition), without Dirichlet constraints — requiring a small regularization term `ε·u·v` to ensure solution uniqueness.

### 8. Nonlinear Transient Problems — `11 Problemas evolutivo y no lineales/`

Extends the transient solver to problems with:
- Nonlinear boundary conditions ([radiation](https://en.wikipedia.org/wiki/Thermal_radiation) on one face, convection on another)
- A **convergence stopping criterion** based on the H¹ semi-norm and L² norm of the difference between successive time steps:

```
stop when: √(‖∇(u - u_old)‖² + ‖u - u_old‖²) < TOL
```

### 9. Incompressible Navier-Stokes — `12 NAVIER STOKES FLUJO INCOMPRESIBLE/`

The most advanced section. Solves the [incompressible Navier-Stokes equations](https://en.wikipedia.org/wiki/Navier%E2%80%93Stokes_equations) using the [Chorin projection method](https://en.wikipedia.org/wiki/Projection_method_(fluid_dynamics)) (pressure-velocity splitting):

```
∂u/∂t + (u·∇)u - ν·Δu + ∇p = 0
∇·u = 0
```

Applications include:

| File | Simulation |
|------|-----------|
| `3 NAVIER STOKES escalon` | Flow over a [backward-facing step](https://en.wikipedia.org/wiki/Backward-facing_step) |
| `23 a naca012 perfil ala` | [NACA 0012 airfoil](https://en.wikipedia.org/wiki/NACA_airfoil) at angle of attack |
| `14 ventilac local profundo` | Deep local ventilation |
| `24 vent inclinada` | Inclined ventilation with wall convection |
| `8 Wind profile` | [Atmospheric boundary layer](https://en.wikipedia.org/wiki/Atmospheric_boundary_layer) wind flow around buildings |
| `110 b GENERACION MALLA` | Cross-ventilation mesh generation |

#### NACA 0012 Airfoil Detail

The airfoil geometry is parameterized analytically using the standard [NACA 4-digit series](https://en.wikipedia.org/wiki/NACA_airfoil) formula:

```
y = ±0.17735√t − 0.075597t − 0.212836t² + 0.17363t³ − 0.06254t⁴
```

The simulation runs at V = 83.3 m/s (~300 km/h), angle of attack = 10°, kinematic viscosity ν = 1.45×10⁻⁵ m²/s. [Streamlines](https://en.wikipedia.org/wiki/Streamlines,_streaklines,_and_pathlines) are computed post-processing via a stream function solve.

#### Wind Profile — MATLAB Utilities (`variacion viento en altura/`)

A companion set of MATLAB scripts models the [logarithmic wind profile](https://en.wikipedia.org/wiki/Log_wind_profile) for atmospheric flow (Pasquill stability classes) and feeds the resulting velocity boundary condition into FreeFEM:

| Script | Purpose |
|--------|---------|
| `perfil_viento.m` | **Entry point** — calls all others |
| `perfil_logaritmico.m` | Logarithmic height profile |
| `velocidad_a_10m.m` | Reference wind speed at 10 m |
| `CEPasquill.m` | [Pasquill-Gifford stability class](https://en.wikipedia.org/wiki/Pasquill_stability_classes) coefficients |
| `escribe_formula.m` | Writes FreeFEM-compatible formula strings |
| `escribe_resultado.m` | Writes output results |

> ⚠️ Only `perfil_viento.m` should be executed directly — all other scripts are called internally.

---

## Key PDE Concepts

| Concept | Wikipedia |
|---------|-----------|
| Finite Element Method | [FEM](https://en.wikipedia.org/wiki/Finite_element_method) |
| Weak / variational formulation | [Weak formulation](https://en.wikipedia.org/wiki/Weak_formulation) |
| Heat equation | [Heat equation](https://en.wikipedia.org/wiki/Heat_equation) |
| Convection-diffusion equation | [Convection-diffusion](https://en.wikipedia.org/wiki/Convection%E2%80%93diffusion_equation) |
| Navier-Stokes equations | [Navier-Stokes](https://en.wikipedia.org/wiki/Navier%E2%80%93Stokes_equations) |
| Chorin projection method | [Projection method](https://en.wikipedia.org/wiki/Projection_method_(fluid_dynamics)) |
| Backward Euler time integration | [Implicit Euler](https://en.wikipedia.org/wiki/Backward_Euler_method) |
| Dirichlet boundary condition | [Dirichlet BC](https://en.wikipedia.org/wiki/Dirichlet_boundary_condition) |
| Neumann boundary condition | [Neumann BC](https://en.wikipedia.org/wiki/Neumann_boundary_condition) |
| Newton's law of cooling | [Convective heat transfer](https://en.wikipedia.org/wiki/Convective_heat_transfer) |
| Adaptive mesh refinement | [AMR](https://en.wikipedia.org/wiki/Adaptive_mesh_refinement) |
| Method of characteristics | [Characteristics](https://en.wikipedia.org/wiki/Method_of_characteristics) |
| Material derivative | [Material derivative](https://en.wikipedia.org/wiki/Material_derivative) |
| NACA airfoil | [NACA airfoil](https://en.wikipedia.org/wiki/NACA_airfoil) |
| Log wind profile | [Log wind profile](https://en.wikipedia.org/wiki/Log_wind_profile) |
| Streamlines | [Streamlines](https://en.wikipedia.org/wiki/Streamlines,_streaklines,_and_pathlines) |

---

## Finite Element Spaces Used

| Space | Degree | Typical Use |
|-------|--------|-------------|
| `P0`  | 0 (constant per element) | Mesh size inspection (`hTriangle`) |
| `P1`  | 1 (linear) | Temperature fields, multi-material problems |
| `P2`  | 2 (quadratic) | Higher accuracy velocity/pressure fields |

---

## Requirements

- [FreeFEM++](https://freefem.org/) (version 4.x recommended)
- MATLAB (only for wind profile utilities in `variacion viento en altura/`)

### Running a Script

```bash
FreeFem++ ejercicio_EDP_2_estacionario.edp
```