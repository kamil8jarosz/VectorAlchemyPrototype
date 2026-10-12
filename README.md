# Alchemy — Game Prototype

A 1D alchemy experimentation game built with **Godot 4**. Explore the relationship between Fire and Water energies, process ingredients, create mixtures, and discover new alchemical properties.

> **Project status:** Prototype  
> This repository contains an early gameplay implementation focused on experimentation, discovery, and core systems.

## Overview

The player experiments with ingredients whose Fire and Water energies determine their position on an alchemical number line.

- **Fire** pulls a mixture toward the left.
- **Balance** is the center point, at position `0`.
- **Water** pulls a mixture toward the right.

By combining ingredients and applying processing stations, the player attempts to reach discovery zones and unlock new ingredients, processing stations, and experimentation possibilities.

The central gameplay loop is:

**Observe → Hypothesize → Process → Combine → Discover → Experiment again**

## Core Mechanics

### 1. Fire and Water energy

Each ingredient has two energy values:

- `fire`
- `water`

The ingredient's net balance is calculated as:

`balance = water - fire`

Examples:

| Fire | Water | Balance | Direction |
|---:|---:|---:|---|
| 1 | 3 | +2 | Water |
| 3 | 1 | -2 | Fire |
| 2 | 2 | 0 | Balanced |

The player can inspect an ingredient's composition and use the preview marker to understand how adding it will affect the mixture.

### 2. Mixtures

Ingredients can be combined into a mixture. The mixture's total Fire and Water energies are the sums of the energies contributed by its entries.

Each mixture entry stores an ingredient and its selected processing station.

The prototype starts with a mixture capacity of **three ingredients**. Discoveries can increase this limit.

### 3. Processing stations

Processing stations modify an ingredient's energy before it contributes to the mixture.

The current processing model includes:

- **No Processing:** Leaves the ingredient unchanged.
- **Fire Separation:** Removes Fire energy.
- **Water Separation:** Removes Water energy.

Each ingredient entry can have at most one processing operation applied to it. Processing is evaluated from the ingredient's original energy, so the same ingredient can be reused in different experiments.

### 4. Discovery zones

Discoveries are associated with intervals on the number line rather than single exact positions.

When the mixture reaches a discovery zone, the player can attempt to discover the corresponding result.

Discoveries can reward the player with:

- New ingredients
- New processing stations
- Additional mixture capacity
- Access to further discoveries

Some discoveries unlock other discoveries, gradually expanding the set of available experiments.

The code separates gameplay rules, progression data, and UI responsibilities.

### Main systems

| Component | Responsibility |
|---|---|
| `Game` | Coordinates gameplay actions and connects the main systems. |
| `Mixture` | Stores mixture entries and calculates total energy and balance. |
| `MixtureEntry` | Associates an ingredient with its selected processing station. |
| `AlchemyDiscovery` | Manages available discoveries and resolves discovery attempts. |
| `AlchemyProgress` | Tracks completed discoveries, unlocked ingredients, unlocked stations, and mixture capacity. |
| `Discovery` | Resource containing discovery conditions, descriptions, rewards, and unlock relationships. |
| `Energy` | Represents Fire and Water energy values. |
| `IngredientData` | Defines an ingredient and its energy composition. |
| `ProcessingStation` | Defines the interface for processing an ingredient's energy. |
| `NumberLine` / `AlchemyLine` | Renders the number line, positions, markers, and discovery zones. |
| `NumberLineEffects` | Handles visual feedback such as the marker landing animation. |
| `Tutorial` | Guides the player through the first experiment using UI interactions and signals. |

### Design principles

- **Gameplay orchestration belongs in `Game`.** Individual systems remain responsible for their own rules.
- **Progression state belongs in `AlchemyProgress`.** It tracks what the player has unlocked or completed.
- **Discovery availability belongs in `AlchemyDiscovery`.** It manages the active discovery pool and handles discovery attempts.
- **Content is data-driven.** Ingredients, stations, and discoveries are represented by Godot Resources.
- **UI components expose semantic methods and signals.** For example, the tutorial can enable ingredient selection or await a discovery event without implementing those controls itself.

## Resource Model

The prototype uses custom Godot Resources to define game content.

### Energy

Represents an ingredient's elemental composition.

```gdscript
class_name Energy
extends Resource

@export var fire: float = 0.0
@export var water: float = 0.0

func get_balance() -> float:
    return water - fire
```

### IngredientData

Defines an ingredient and its energy.

```gdscript
class_name IngredientData
extends Resource

@export var ingredient_name: String
@export var energy: Energy
```

### ProcessingStation

Provides a common interface for processing energy.

```gdscript
class_name ProcessingStation
extends Resource

@export var display_name: String

func process(energy: Energy) -> Energy:
    return energy
```

Specialized stations override `process()` to implement their transformations.

### Discovery

A discovery Resource defines its name, description, hint, position interval, rewards, and any additional discoveries it unlocks.

```gdscript
class_name Discovery
extends Resource

@export var discovery_name: String
@export_multiline var description: String
@export_multiline var hint: String

@export var min_position: float
@export var max_position: float

@export var unlocked_ingredients: Array[IngredientData]
@export var unlocked_stations: Array[ProcessingStation]
@export var unlocked_discoveries: Array[Discovery]
@export var max_mixture_capacity: int = 0

func contains_position(position: float) -> bool:
    return position >= min_position and position <= max_position
```

Discovery definitions can reference other Discovery Resources directly, allowing progression to be configured in the Godot Inspector rather than hard-coded into gameplay logic.

## Tutorial

The tutorial is implemented as a sequence of interactions rather than a passive text introduction.

It uses signals and `await` to pause until the player performs an action, such as selecting an ingredient, adding it to the mixture, or attempting a discovery.

This keeps the tutorial aligned with actual gameplay and allows UI components to retain ownership of their own controls.

## Building the Project

1. Install a compatible version of **Godot 4**.
2. Clone or download this repository.
3. Open the project using Godot's Project Manager.
4. Run the configured main scene.

The project is a prototype, so scene setup, resource definitions, and input behavior may change as the mechanics evolve.

## Current Scope

The prototype focuses on validating the central experimentation loop:

- [x] Fire/Water energy model
- [x] Ingredient composition and mixture calculations
- [x] Ingredient processing through stations
- [x] Preview and committed mixture positions
- [x] Discovery zones on the number line
- [x] Discovery rewards and progression
- [x] Discovery chains
- [x] Mixture capacity progression
- [x] Guided first-experiment tutorial
- [x] Discovery result and journal UI

## Future Development

Potential areas for further development include:

- Expansion to 2D with Air and Earth
- More ingredients and processing stations
- More complex discovery chains
- Additional discovery conditions and rewards
- Improved feedback for invalid experiments
- Expanded journal and experimentation UX
- Further balancing and playtesting

These are possible directions rather than commitments for the current prototype.
