# 🏏 IPL Auction Management System (DBMS Project)

This project simulates an **Indian Premier League (IPL) Auction System** using SQL and PL/SQL concepts. It enables efficient management of player auctions, team finances, owner data, and dynamic auction activities using **MySQL database procedures, triggers, and queries**.

---

## 📌 Features

- 💼 Player and Team data management
- ⚙️ Stored procedures for adding players, bidding, selling, and viewing
- 🔁 Triggers for automatic ID assignment and team balance updates
- 🔐 Admin authentication table
- 📊 Team owner and player statistics
- ✅ Supports realistic auction testing scenarios

---

## 🛠️ Tech Stack

- **Database:** MySQL
- **Language:** SQL + PL/SQL (MySQL-compatible)
- **Environment:** MySQL Workbench / XAMPP / phpMyAdmin

---

## 📂 Database Structure

### Tables:
- `Admin`: Stores admin login credentials
- `Team`: Stores team name, balance, player count, and captain
- `Player`: Stores player IDs and names
- `Player_details`: Stores player stats and auction details
- `Owners`: Stores team owners

### Stored Procedures:
- `add_player`: Add a new player to the system
- `sell_player`: Mark player as sold and update team info
- `register_bid`: Handle bidding logic with price validation
- `print_player`: View full player details
- `print_team`: View full team details

### Triggers:
- `trg_auto_add_player`: Automatically adds entry to `Player` table when a new player is added
- `trg_team_update_on_sell`: Updates team balance and player count when a player is sold

---

## 🚀 How to Set It Up

### 1. Clone this Repository

```bash
git clone https://github.com/your-username/ipl-auction-dbms.git
cd ipl-auction-dbms
