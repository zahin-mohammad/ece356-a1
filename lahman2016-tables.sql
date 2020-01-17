\W
CREATE DATABASE  IF NOT EXISTS `baseball2016` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `baseball2016`;

/*

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50709
 Source Host           : localhost
 Source Database       : lahman2016

 Target Server Type    : MySQL
 Target Server Version : 50709
 File Encoding         : utf-8

 Date: 02/25/2017 08:32:12 AM
*/

-- ----------------------------
--  Table structure for `Master`
-- ----------------------------
DROP TABLE IF EXISTS `Master`;
CREATE TABLE `Master` (
  `playerID` varchar(255) NOT NULL,
  `birthYear` int DEFAULT NULL,
  `birthMonth` int DEFAULT NULL,
  `birthDay` int DEFAULT NULL,
  `birthCountry` varchar(255) DEFAULT NULL,
  `birthState` varchar(255) DEFAULT NULL,
  `birthCity` varchar(255) DEFAULT NULL,
  `deathYear` varchar(255) DEFAULT NULL,
  `deathMonth` varchar(255) DEFAULT NULL,
  `deathDay` varchar(255) DEFAULT NULL,
  `deathCountry` varchar(255) DEFAULT NULL,
  `deathState` varchar(255) DEFAULT NULL,
  `deathCity` varchar(255) DEFAULT NULL,
  `nameFirst` varchar(255) DEFAULT NULL,
  `nameLast` varchar(255) DEFAULT NULL,
  `nameGiven` varchar(255) DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `height` int DEFAULT NULL,
  `bats` varchar(255) DEFAULT NULL,
  `throws` varchar(255) DEFAULT NULL,
  `debut` varchar(255) DEFAULT NULL,
  `finalGame` varchar(255) DEFAULT NULL,
  `retroID` varchar(255) DEFAULT NULL,
  `bbrefID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `TeamsFranchises`
-- ----------------------------
DROP TABLE IF EXISTS `TeamsFranchises`;
CREATE TABLE `TeamsFranchises` (
  `franchID` varchar(255) NOT NULL,
  `franchName` varchar(255) DEFAULT NULL,
  `active` varchar(255) DEFAULT NULL,
  `NAassoc` varchar(255) DEFAULT NULL,
  PRIMARY KEY(`franchID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Schools`
-- ----------------------------
DROP TABLE IF EXISTS `Schools`;
CREATE TABLE `Schools` (
  `schoolID` varchar(255) NOT NULL,
  `name_full` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  PRIMARY KEY(`schoolID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Teams`
-- ----------------------------
DROP TABLE IF EXISTS `Teams`;
CREATE TABLE `Teams` (
  `yearID` int NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `teamID` varchar(255) NOT NULL,
  `franchID` varchar(255) DEFAULT NULL,
  `divID` varchar(255) DEFAULT NULL,
  `Rank` int DEFAULT NULL,
  `G` int DEFAULT NULL,
  `Ghome` varchar(255) DEFAULT NULL,
  `W` int DEFAULT NULL,
  `L` int DEFAULT NULL,
  `DivWin` varchar(255) DEFAULT NULL,
  `WCWin` varchar(255) DEFAULT NULL,
  `LgWin` varchar(255) DEFAULT NULL,
  `WSWin` varchar(255) DEFAULT NULL,
  `R` int DEFAULT NULL,
  `AB` int DEFAULT NULL,
  `H` int DEFAULT NULL,
  `2B` int DEFAULT NULL,
  `3B` int DEFAULT NULL,
  `HR` int DEFAULT NULL,
  `BB` int DEFAULT NULL,
  `SO` int DEFAULT NULL,
  `SB` int DEFAULT NULL,
  `CS` varchar(255) DEFAULT NULL,
  `HBP` varchar(255) DEFAULT NULL,
  `SF` varchar(255) DEFAULT NULL,
  `RA` int DEFAULT NULL,
  `ER` int DEFAULT NULL,
  `ERA` float DEFAULT NULL,
  `CG` int DEFAULT NULL,
  `SHO` int DEFAULT NULL,
  `SV` int DEFAULT NULL,
  `IPouts` int DEFAULT NULL,
  `HA` int DEFAULT NULL,
  `HRA` int DEFAULT NULL,
  `BBA` int DEFAULT NULL,
  `SOA` int DEFAULT NULL,
  `E` int DEFAULT NULL,
  `DP` varchar(255) DEFAULT NULL,
  `FP` float DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `park` varchar(255) DEFAULT NULL,
  `attendance` varchar(255) DEFAULT NULL,
  `BPF` int DEFAULT NULL,
  `PPF` int DEFAULT NULL,
  `teamIDBR` varchar(255) DEFAULT NULL,
  `teamIDlahman45` varchar(255) DEFAULT NULL,
  `teamIDretro` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`teamID`, `yearID`),
  FOREIGN KEY (`franchID`) REFERENCES TeamsFranchises(`franchID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Parks`
-- ----------------------------
DROP TABLE IF EXISTS `Parks`;
CREATE TABLE `Parks` (
  `park.key` varchar(255) NOT NULL,
  `park.name` varchar(255) DEFAULT NULL,
  `park.alias` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`park.key`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


-- ----------------------------
--  Table structure for `AllstarFull`
-- ----------------------------
DROP TABLE IF EXISTS `AllstarFull`;
CREATE TABLE `AllstarFull` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `gameNum` int DEFAULT NULL,
  `gameID` varchar(255) NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `GP` int DEFAULT NULL,
  `startingPos` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`teamID`,`gameID`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Appearances`
-- ----------------------------
DROP TABLE IF EXISTS `Appearances`;
CREATE TABLE `Appearances` (
  `yearID` int NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) NOT NULL,
  `playerID` varchar(255) NOT NULL,
  `G_all` int DEFAULT NULL,
  `GS` varchar(255) DEFAULT NULL,
  `G_batting` int DEFAULT NULL,
  `G_defense` int DEFAULT NULL,
  `G_p` int DEFAULT NULL,
  `G_c` int DEFAULT NULL,
  `G_1b` int DEFAULT NULL,
  `G_2b` int DEFAULT NULL,
  `G_3b` int DEFAULT NULL,
  `G_ss` int DEFAULT NULL,
  `G_lf` int DEFAULT NULL,
  `G_cf` int DEFAULT NULL,
  `G_rf` int DEFAULT NULL,
  `G_of` int DEFAULT NULL,
  `G_dh` varchar(255) DEFAULT NULL,
  `G_ph` varchar(255) DEFAULT NULL,
  `G_pr` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`teamID`,`lgID`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `AwardsManagers`
-- ----------------------------
DROP TABLE IF EXISTS `AwardsManagers`;
CREATE TABLE `AwardsManagers` (
  `playerID` varchar(255) NOT NULL,
  `awardID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `lgID` varchar(255) NOT NULL,
  `tie` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`lgID`,`awardID`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `AwardsPlayers`
-- ----------------------------
DROP TABLE IF EXISTS `AwardsPlayers`;
CREATE TABLE `AwardsPlayers` (
  `playerID` varchar(255) NOT NULL,
  `awardID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `lgID` varchar(255) NOT NULL,
  `tie` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`lgID`,`awardID`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `AwardsShareManagers`
-- ----------------------------
DROP TABLE IF EXISTS `AwardsShareManagers`;
CREATE TABLE `AwardsShareManagers` (
  `awardID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `lgID` varchar(255) NOT NULL,
  `playerID` varchar(255) NOT NULL,
  `pointsWon` int DEFAULT NULL,
  `pointsMax` int DEFAULT NULL,
  `votesFirst` int DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`lgID`,`awardID`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `AwardsSharePlayers`
-- ----------------------------
DROP TABLE IF EXISTS `AwardsSharePlayers`;
CREATE TABLE `AwardsSharePlayers` (
  `awardID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `lgID` varchar(255) NOT NULL,
  `playerID` varchar(255) NOT NULL,
  `pointsWon` int DEFAULT NULL,
  `pointsMax` int DEFAULT NULL,
  `votesFirst` int DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`lgID`,`awardID`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Batting`
-- ----------------------------
DROP TABLE IF EXISTS `Batting`;
CREATE TABLE `Batting` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `stint` int NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) NOT NULL,
  `G` int DEFAULT NULL,
  `AB` int DEFAULT NULL,
  `R` int DEFAULT NULL,
  `H` int DEFAULT NULL,
  `2B` int DEFAULT NULL,
  `3B` int DEFAULT NULL,
  `HR` int DEFAULT NULL,
  `RBI` int DEFAULT NULL,
  `SB` int DEFAULT NULL,
  `CS` int DEFAULT NULL,
  `BB` int DEFAULT NULL,
  `SO` int DEFAULT NULL,
  `IBB` varchar(255) DEFAULT NULL,
  `HBP` varchar(255) DEFAULT NULL,
  `SH` varchar(255) DEFAULT NULL,
  `SF` varchar(255) DEFAULT NULL,
  `GIDP` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`teamID`,`lgID`,`stint`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `BattingPost`
-- ----------------------------
DROP TABLE IF EXISTS `BattingPost`;
CREATE TABLE `BattingPost` (
  `yearID` int NOT NULL,
  `round` varchar(255) NOT NULL,
  `playerID` varchar(255) NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `G` int DEFAULT NULL,
  `AB` int DEFAULT NULL,
  `R` int DEFAULT NULL,
  `H` int DEFAULT NULL,
  `2B` int DEFAULT NULL,
  `3B` int DEFAULT NULL,
  `HR` int DEFAULT NULL,
  `RBI` int DEFAULT NULL,
  `SB` int DEFAULT NULL,
  `CS` varchar(255) DEFAULT NULL,
  `BB` int DEFAULT NULL,
  `SO` int DEFAULT NULL,
  `IBB` int DEFAULT NULL,
  `HBP` varchar(255) DEFAULT NULL,
  `SH` varchar(255) DEFAULT NULL,
  `SF` varchar(255) DEFAULT NULL,
  `GIDP` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`teamID`,`round`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `CollegePlaying`
-- ----------------------------
DROP TABLE IF EXISTS `CollegePlaying`;
CREATE TABLE `CollegePlaying` (
  `playerID` varchar(255) NOT NULL,
  `schoolID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  PRIMARY KEY (`playerID`, `schoolID`, `yearID`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`schoolID`) REFERENCES Schools(`schoolID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Fielding`
-- ----------------------------
DROP TABLE IF EXISTS `Fielding`;
CREATE TABLE `Fielding` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `stint` int NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `POS` varchar(255) NOT NULL,
  `G` int DEFAULT NULL,
  `GS` varchar(255) DEFAULT NULL,
  `InnOuts` varchar(255) DEFAULT NULL,
  `PO` int DEFAULT NULL,
  `A` int DEFAULT NULL,
  `E` int DEFAULT NULL,
  `DP` int DEFAULT NULL,
  `PB` varchar(255) DEFAULT NULL,
  `WP` varchar(255) DEFAULT NULL,
  `SB` varchar(255) DEFAULT NULL,
  `CS` varchar(255) DEFAULT NULL,
  `ZR` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`teamID`,`POS`,`stint`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `FieldingOF`
-- ----------------------------
DROP TABLE IF EXISTS `FieldingOF`;
CREATE TABLE `FieldingOF` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `stint` int NOT NULL,
  `Glf` int DEFAULT NULL,
  `Gcf` int DEFAULT NULL,
  `Grf` int DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`stint`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`) 
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `FieldingOFsplit`
-- ----------------------------
DROP TABLE IF EXISTS `FieldingOFsplit`;
CREATE TABLE `FieldingOFsplit` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `stint` int NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `POS` varchar(255) NOT NULL,
  `G` int DEFAULT NULL,
  `GS` int DEFAULT NULL,
  `InnOuts` int DEFAULT NULL,
  `PO` int DEFAULT NULL,
  `A` int DEFAULT NULL,
  `E` int DEFAULT NULL,
  `DP` int DEFAULT NULL,
  `PB` varchar(255) DEFAULT NULL,
  `WP` varchar(255) DEFAULT NULL,
  `SB` varchar(255) DEFAULT NULL,
  `CS` varchar(255) DEFAULT NULL,
  `ZR` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`, `yearID`, `teamID`, `POS`,`stint`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `FieldingPost`
-- ----------------------------
DROP TABLE IF EXISTS `FieldingPost`;
CREATE TABLE `FieldingPost` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `teamID` varchar(255) DEFAULT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `round` varchar(255) NOT NULL,
  `POS` varchar(255) NOT NULL,
  `G` int DEFAULT NULL,
  `GS` int DEFAULT NULL,
  `InnOuts` int DEFAULT NULL,
  `PO` int DEFAULT NULL,
  `A` int DEFAULT NULL,
  `E` int DEFAULT NULL,
  `DP` int DEFAULT NULL,
  `TP` int DEFAULT NULL,
  `PB` varchar(255) DEFAULT NULL,
  `SB` varchar(255) DEFAULT NULL,
  `CS` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`POS`,`round`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `HallOfFame`
-- ----------------------------
DROP TABLE IF EXISTS `HallOfFame`;
CREATE TABLE `HallOfFame` (
  `playerID` varchar(255) NOT NULL,
  `yearid` int NOT NULL,
  `votedBy` varchar(255) NOT NULL,
  `ballots` int DEFAULT NULL,
  `needed` int DEFAULT NULL,
  `votes` int DEFAULT NULL,
  `inducted` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `needed_note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`votedBy`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `HomeGames`
-- ----------------------------
DROP TABLE IF EXISTS `HomeGames`;
CREATE TABLE `HomeGames` (
  `year.key` int NOT NULL,
  `league.key` varchar(255) DEFAULT NULL,
  `team.key` varchar(255) NOT NULL,
  `park.key` varchar(255) NOT NULL,
  `span.first` varchar(255) DEFAULT NULL,
  `span.last` varchar(255) DEFAULT NULL,
  `games` int DEFAULT NULL,
  `openings` int DEFAULT NULL,
  `attendance` int DEFAULT NULL,
  PRIMARY KEY (`park.key`,`team.key`,`year.key`),
  FOREIGN KEY (`park.key`) REFERENCES Parks(`park.key`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Managers`
-- ----------------------------
DROP TABLE IF EXISTS `Managers`;
CREATE TABLE `Managers` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `inseason` int NOT NULL,
  `G` int DEFAULT NULL,
  `W` int DEFAULT NULL,
  `L` int DEFAULT NULL,
  `rank` int DEFAULT NULL,
  `plyrMgr` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`, `yearID`, `teamID`, `inseason`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


-- ----------------------------
--  Table structure for `ManagersHalf`
-- ----------------------------
DROP TABLE IF EXISTS `ManagersHalf`;
CREATE TABLE `ManagersHalf` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `inseason` int NOT NULL,
  `half` int NOT NULL,
  `G` int DEFAULT NULL,
  `W` int DEFAULT NULL,
  `L` int DEFAULT NULL,
  `rank` int DEFAULT NULL,
   PRIMARY KEY (`playerID`, `yearID`, `teamID`, `inseason`, `half`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Pitching`
-- ----------------------------
DROP TABLE IF EXISTS `Pitching`;
CREATE TABLE `Pitching` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `stint` int NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `W` int DEFAULT NULL,
  `L` int DEFAULT NULL,
  `G` int DEFAULT NULL,
  `GS` int DEFAULT NULL,
  `CG` int DEFAULT NULL,
  `SHO` int DEFAULT NULL,
  `SV` int DEFAULT NULL,
  `IPouts` int DEFAULT NULL,
  `H` int DEFAULT NULL,
  `ER` int DEFAULT NULL,
  `HR` int DEFAULT NULL,
  `BB` int DEFAULT NULL,
  `SO` int DEFAULT NULL,
  `BAOpp` varchar(255) DEFAULT NULL,
  `ERA` float DEFAULT NULL,
  `IBB` varchar(255) DEFAULT NULL,
  `WP` varchar(255) DEFAULT NULL,
  `HBP` varchar(255) DEFAULT NULL,
  `BK` int DEFAULT NULL,
  `BFP` varchar(255) DEFAULT NULL,
  `GF` varchar(255) DEFAULT NULL,
  `R` int DEFAULT NULL,
  `SH` varchar(255) DEFAULT NULL,
  `SF` varchar(255) DEFAULT NULL,
  `GIDP` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playerID`,`yearID`,`teamID`, `stint`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `PitchingPost`
-- ----------------------------
DROP TABLE IF EXISTS `PitchingPost`;
CREATE TABLE `PitchingPost` (
  `playerID` varchar(255) NOT NULL,
  `yearID` int NOT NULL,
  `round` varchar(255) NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `W` int DEFAULT NULL,
  `L` int DEFAULT NULL,
  `G` int DEFAULT NULL,
  `GS` int DEFAULT NULL,
  `CG` int DEFAULT NULL,
  `SHO` int DEFAULT NULL,
  `SV` int DEFAULT NULL,
  `IPouts` int DEFAULT NULL,
  `H` int DEFAULT NULL,
  `ER` int DEFAULT NULL,
  `HR` int DEFAULT NULL,
  `BB` int DEFAULT NULL,
  `SO` int DEFAULT NULL,
  `BAOpp` float DEFAULT NULL,
  `ERA` varchar(255) DEFAULT NULL,
  `IBB` int DEFAULT NULL,
  `WP` int DEFAULT NULL,
  `HBP` int DEFAULT NULL,
  `BK` int DEFAULT NULL,
  `BFP` int DEFAULT NULL,
  `GF` int DEFAULT NULL,
  `R` int DEFAULT NULL,
  `SH` int DEFAULT NULL,
  `SF` int DEFAULT NULL,
  `GIDP` int DEFAULT NULL,
  PRIMARY KEY (`playerID`, `yearID`,`teamID`,`round`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `Salaries`
-- ----------------------------
DROP TABLE IF EXISTS `Salaries`;
CREATE TABLE `Salaries` (
  `yearID` int NOT NULL,
  `teamID` varchar(255) NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `playerID` varchar(255) NOT NULL,
  `salary` int DEFAULT NULL,
  PRIMARY KEY (`yearID`, `teamID`, `playerID`),
  FOREIGN KEY (`playerID`) REFERENCES Master(`playerID`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `SeriesPost`
-- ----------------------------
DROP TABLE IF EXISTS `SeriesPost`;
CREATE TABLE `SeriesPost` (
  `yearID` int NOT NULL,
  `round` varchar(255) NOT NULL,
  `teamIDwinner` varchar(255) NOT NULL,
  `lgIDwinner` varchar(255) DEFAULT NULL,
  `teamIDloser` varchar(255) NOT NULL,
  `lgIDloser` varchar(255) DEFAULT NULL,
  `wins` int DEFAULT NULL,
  `losses` int DEFAULT NULL,
  `ties` int DEFAULT NULL,
  PRIMARY KEY (`yearID`, `round`,`teamIDWinner`,`teamIDLoser`),
  FOREIGN KEY (`teamIDwinner`) REFERENCES Teams(`teamID`),
  FOREIGN KEY (`teamIDloser`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- ----------------------------
--  Table structure for `TeamsHalf`
-- ----------------------------
DROP TABLE IF EXISTS `TeamsHalf`;
CREATE TABLE `TeamsHalf` (
  `yearID` int NOT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `teamID` varchar(255) NOT NULL,
  `Half` int NOT NULL,
  `divID` varchar(255) DEFAULT NULL,
  `DivWin` varchar(255) DEFAULT NULL,
  `Rank` int DEFAULT NULL,
  `G` int DEFAULT NULL,
  `W` int DEFAULT NULL,
  `L` decimal(11) DEFAULT NULL,
  PRIMARY KEY (`yearID`,`teamID`,`Half`),
  FOREIGN KEY (`teamID`) REFERENCES Teams(`teamID`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;
\w