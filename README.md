# Alchemy — Game Prototype

A 2D alchemy experimentation game built with **Godot 4**. Explore the relationship between Fire and Water energies, process ingredients, create mixtures, and discover new alchemical properties.

> **Project status:** Prototype  
> This repository contains an early gameplay implementation focused on experimentation, discovery, and core systems.

## Overview

The player experiments with ingredients whose Fire and Water energies determine their position on an alchemical number line.

- **Balance** is the center point, at position `0`.
- **Fire** pulls the mixture toward the left.
- **Water** pulls the mixture toward the right.
- **Air** pulls the mixture upwards.
- **Earth** pulls the mixture downwards.

By combining ingredients and applying processing stations, the player attempts to reach discovery zones and unlock new ingredients, processing stations, and experimentation possibilities.

The central gameplay loop is:

**Observe → Hypothesize → Process → Combine → Discover → Experiment again**

## Core Mechanics

### 1. Fire and Water energy

Each ingredient has four energy values:

- `fire`
- `water`
- `air`
- `earth`

The ingredient's movement is calculated as:

`(water - fire, air - earth)`

The player can inspect an ingredient's composition and use the preview marker to understand how adding it will affect the mixture.

### 2. Mixtures

Ingredients can be combined into a mixture. The mixture's total energies are the sums of the energies contributed by its entries.

The prototype starts with a mixture capacity of **two ingredients**. Discoveries can increase this limit.

### 3. Processing stations

Processing stations are not currently implemented in 0.4.0 version. Playtesting revealed that they were confusing players.

I believe they would be a good addition later in the game, when the players are familiar with elemental energy and cancellation. 

### 4. Discovery zones

Discoveries are associated with rectangles on the alchemical map. When second dimension is hidden, they becomes intervals on number line.

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
| `Energy` | Represents Fire, Water, Air, and Earth energy values. |
| `IngredientData` | Defines an ingredient and its energy composition. |
| `AlchemyMap` | Renders the number line/space, positions, markers, and discovery zones. |
| `Tutorial` | Guides the player through the first experiment using UI interactions and signals. |

## Resource Model

The prototype uses custom Godot Resources to define game content:
- Ingredients
- Discoveries

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

- [x] Elemental energy model
- [x] Ingredient composition and mixture calculations
- [x] Two-dimensional elemental space 
- [x] Preview and committed mixture positions
- [x] Discovery rewards and progression
- [x] Mixture capacity progression
- [x] Guided first-experiment tutorial
- [x] Discovery result and journal UI

## Future Development

Potential areas for further development include:

- Processing stations
- More complex discovery chains
- Additional discovery conditions and rewards
- Improved feedback for unsuccessful experiments
- Further balancing and playtesting

These are possible directions rather than commitments for the current prototype.
