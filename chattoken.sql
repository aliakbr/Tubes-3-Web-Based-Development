-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 30, 2016 at 04:02 AM
-- Server version: 5.6.16
-- PHP Version: 5.5.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `chattoken`
--

-- --------------------------------------------------------

--
-- Table structure for table `chattoken`
--

CREATE TABLE IF NOT EXISTS `chattoken` (
  `chattoken` varchar(4096) NOT NULL,
  `username` varchar(15) NOT NULL,
  `user_id` int(15) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `chattoken`
--

INSERT INTO `chattoken` (`chattoken`, `username`, `user_id`) VALUES
('fCstHDVcJFU:APA91bFGWLstDAZsMrLoFNdEWIGTIhq7xtdHXHXAc9jLYHnAdD8tLf1sIz8vfIjgTon21KPJtWMPWVTz1lhppU6vB-moNw71sWb8ibQxdLp5XWfC3_8oRKtByWuEcJWQxRryvVLuRlED', '11', 11);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
