CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,    -- Assuming auto-incrementing ID
    Username VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,           -- Assuming hashed & salted password storage
    Email VARCHAR(255) UNIQUE NOT NULL,       -- UNIQUE ensures no two users have the same email
    DateCreated DATETIME DEFAULT CURRENT_TIMESTAMP,
    LastLogin DATETIME,
    LastSeen DATETIME,
    AccountStatus ENUM('active', 'deactivated') DEFAULT 'active',
    ProfileImage VARCHAR(255),                -- This can be a link to where the image is stored, perhaps on AWS S3
    ProfileDescription TEXT,                  -- TEXT type is useful for longer descriptions
    DietaryRestrictions TEXT,                 -- Can store as comma-separated values, or consider normalizing further
    Allergens TEXT                            -- Similar to DietaryRestrictions
);
CREATE TABLE NutritionalValues (
    NutritionalValueID INT AUTO_INCREMENT PRIMARY KEY,
    Calories DECIMAL(10, 2),
    Protein DECIMAL(10, 2),
    Fats DECIMAL(10, 2),
    Carbohydrates DECIMAL(10, 2),
    Sodium DECIMAL(10, 2),
    Sugars DECIMAL(10, 2),
    VitaminA DECIMAL(10, 2),
    VitaminC DECIMAL(10, 2),
    Iron DECIMAL(10, 2),
    Others TEXT
);

CREATE TABLE InventoryItems (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    ProductName VARCHAR(255),
    BrandName VARCHAR(255),
    Barcode VARCHAR(255) NULL, -- This can store UPC or other barcodes. NULL means it's optional.
    Category VARCHAR(100),     -- For better organization like 'dairy', 'vegetable', 'meat', etc.
    Quantity INT,
    ExpiryDate DATE,
    DateAdded DATE,
    NutritionalValueID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),             -- Assumes you have a Users table.
    FOREIGN KEY (NutritionalValueID) REFERENCES NutritionalValues(NutritionalValueID) -- Assumes you have a NutritionalValues table.
);



CREATE TABLE Recipes (
    RecipeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    Instructions TEXT,
    TotalCalories DECIMAL(10, 2),
    PreparationTime TIME,
    CuisineType VARCHAR(100),
    DishType VARCHAR(100),
    ImageURL TEXT
);
CREATE TABLE RecipeIngredients (
    RecipeIngredientID INT AUTO_INCREMENT PRIMARY KEY,
    RecipeID INT,
    InventoryItemID INT,  -- Change from ItemName
    Quantity DECIMAL(10,2), 
    NutritionalValueID INT,
    Substitute TEXT,  -- Suggested field
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID),
    FOREIGN KEY (InventoryItemID) REFERENCES InventoryItems(ItemID),
    FOREIGN KEY (NutritionalValueID) REFERENCES NutritionalValues(NutritionalValueID)
);
CREATE TABLE UserRecipes (
    UserRecipeID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    RecipeID INT,
    DateAdded DATE,  -- Suggested field
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID)
);

CREATE TABLE UserActivities (
    ActivityID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Date DATE,
    Action TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Notifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Message TEXT,
    DateCreated DATE,
    Status ENUM('read', 'unread'),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Wastage Table
CREATE TABLE Wastage (
    wastageID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT,
    itemID INT,
    reasonForWastage TEXT,
    dateDiscarded DATE,
    quantityDiscarded DECIMAL(10,2),
    FOREIGN KEY (userID) REFERENCES Users(UserID),
    FOREIGN KEY (itemID) REFERENCES InventoryItems(ItemID)
);

-- UserSettings Table
CREATE TABLE UserSettings (
    settingsID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT,
    notificationPreferences INT,  -- e.g., 3 for "3 days before expiry"
    recipePreferences TEXT,  -- Consider normalizing this further if the list grows
    FOREIGN KEY (userID) REFERENCES Users(UserID)
);
CREATE TABLE Chats (
    chatID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT,
    startTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    endTime TIMESTAMP NULL,  -- Changed this line
    FOREIGN KEY (userID) REFERENCES Users(UserID)
);

-- ChatMessages Table
CREATE TABLE ChatMessages (
    messageID INT AUTO_INCREMENT PRIMARY KEY,
    chatID INT,
    userID INT NULL,  -- Can be NULL if it's a system or ChatGPT message
    content TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chatID) REFERENCES Chats(chatID),
    FOREIGN KEY (userID) REFERENCES Users(UserID)
);