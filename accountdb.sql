-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 10, 2016 at 12:01 PM
-- Server version: 5.6.16
-- PHP Version: 5.5.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `accountdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE IF NOT EXISTS `account` (
  `user_id` int(15) NOT NULL AUTO_INCREMENT,
  `fullname` varchar(30) NOT NULL,
  `username` varchar(15) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `address` text NOT NULL,
  `postal_code` int(5) NOT NULL,
  `phone_number` varchar(12) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`user_id`, `fullname`, `username`, `email`, `password`, `address`, `postal_code`, `phone_number`) VALUES
(0, 'User', 'username', 'username@email.com', 'username', 'user''s address', 12345, '12345678'),
(1, 'a', 'a', 'a@mail.com', 'a', '', 1, '1'),
(2, 'ali muhammad', 'ali_ass3', 'ali_ass3@yahoo.com', 'ali_ass3@yahoo.com', '', 36313, '2147483647'),
(4, 'Azka hanif imtiyaz', 'azkaimtiyaz@gma', 'azkaimtiyaz@gmail.com', 'azkahanif', 'Jl gurame Raya No 44 Sebantengan', 50512, '2147483647'),
(11, 'Kylo Ren', 'kyloren77', 'kyloren77@gmail.com', 'kylo', 'Jalan Tamansari nomor 33. Bandung', 12345, '087722031753'),
(12, 'Yeti', 'yeti8', 'yeti8@gmail.com', 'yeti', 'Jalan Tamansari nomor 33. Bandung', 12345, '089976543210');

-- --------------------------------------------------------

--
-- Table structure for table `token`
--

CREATE TABLE IF NOT EXISTS `token` (
  `user_id` int(11) NOT NULL,
  `token` varchar(20) NOT NULL,
  `expire_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `token`
--

INSERT INTO `token` (`user_id`, `token`, `expire_time`) VALUES
(1, '7u1hm1a1478779100436', '2016-11-10 11:58:20');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
