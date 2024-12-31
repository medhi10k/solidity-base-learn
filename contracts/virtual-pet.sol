// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract VirtualPet {
    // Structure pour stocker les informations de l'animal
    struct Pet {
        string name;
        uint8 hunger;      // 0-100 (100 = affamé)
        uint8 happiness;   // 0-100 (100 = très heureux)
        uint16 experience; // Points d'expérience
        uint8 level;      // Niveau actuel
        uint lastFed;     // Timestamp du dernier repas
        bool isAlive;     // État de l'animal
    }

    // Mapping pour stocker les animaux de chaque propriétaire
    mapping(address => Pet) public pets;
    
    // Events
    event PetCreated(address owner, string name);
    event PetFed(address owner, uint8 newHunger);
    event PetLevelUp(address owner, uint8 newLevel);
    event PetDied(address owner, string name);

    // Erreurs personnalisées
    error PetAlreadyExists();
    error PetDoesNotExist();
    error PetIsDead();
    error TooSoonToFeed();

    // Créer un nouvel animal
    function createPet(string memory _name) public {
        if(pets[msg.sender].isAlive) {
            revert PetAlreadyExists();
        }

        pets[msg.sender] = Pet({
            name: _name,
            hunger: 50,
            happiness: 100,
            experience: 0,
            level: 1,
            lastFed: block.timestamp,
            isAlive: true
        });

        emit PetCreated(msg.sender, _name);
    }

    // Nourrir l'animal
    function feedPet() public {
        Pet storage pet = pets[msg.sender];
        
        if(!pet.isAlive) {
            revert PetIsDead();
        }

        if(block.timestamp - pet.lastFed < 1 hours) {
            revert TooSoonToFeed();
        }

        // Mise à jour de la faim
        if(pet.hunger >= 10) {
            pet.hunger -= 10;
        } else {
            pet.hunger = 0;
        }

        // Gain d'expérience
        pet.experience += 10;
        
        // Vérification du niveau
        if(pet.experience >= pet.level * 100) {
            pet.level++;
            pet.happiness += 10;
            if(pet.happiness > 100) pet.happiness = 100;
            emit PetLevelUp(msg.sender, pet.level);
        }

        pet.lastFed = block.timestamp;
        emit PetFed(msg.sender, pet.hunger);
    }

    // Vérifier l'état de l'animal
    function checkPet() public {
        Pet storage pet = pets[msg.sender];
        
        if(!pet.isAlive) {
            revert PetDoesNotExist();
        }

        // Si l'animal n'a pas été nourri depuis 3 jours, il meurt
        if(block.timestamp - pet.lastFed > 3 days) {
            pet.isAlive = false;
            emit PetDied(msg.sender, pet.name);
        }
        
        // La faim augmente avec le temps
        uint timePassed = (block.timestamp - pet.lastFed) / 1 hours;
        if(timePassed > 0) {
            pet.hunger += uint8(timePassed * 2);
            if(pet.hunger > 100) {
                pet.hunger = 100;
            }
            
            // Le bonheur diminue quand l'animal a faim
            if(pet.hunger > 70 && pet.happiness > 0) {
                pet.happiness -= 5;
            }
        }
    }

    // Obtenir toutes les infos de l'animal
    function getPetInfo() public view returns (
        string memory name,
        uint8 hunger,
        uint8 happiness,
        uint16 experience,
        uint8 level,
        bool isAlive
    ) {
        Pet memory pet = pets[msg.sender];
        return (
            pet.name,
            pet.hunger,
            pet.happiness,
            pet.experience,
            pet.level,
            pet.isAlive
        );
    }
}