-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 13, 2016 at 10:08 AM
-- Server version: 10.1.16-MariaDB
-- PHP Version: 5.6.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `marketplacedb`
--

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `user_id` int(15) NOT NULL,
  `product_id` int(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`user_id`, `product_id`) VALUES
(1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(15) NOT NULL,
  `name` varchar(30) NOT NULL,
  `price` int(12) NOT NULL,
  `description` text NOT NULL,
  `image` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(15) NOT NULL,
  `username` varchar(15) NOT NULL,
  `fullname` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `name`, `price`, `description`, `image`, `date`, `user_id`, `username`, `fullname`) VALUES
(5, 'Baju Baru', 300000, 'Baju baru keren banget loh. Harus beli!', 'product_img/1_Baju_Baru.jpg', '2016-10-07 13:19:27', 1, 'a', 'a'),
(6, 'Baju lama', 10000, 'Baju jelek banget udah lama, habis dipake 2000 kali', 'product_img/2_Baju_lama.jpg', '2016-10-08 12:13:22', 0, 'username', 'User'),
(8, 'Baju Bagus', 50000, 'Ini bajunya bagus banget loh, nyesel kalo ga beli.', 'product_img/3_Baju_jadul.jpg', '2016-10-08 06:41:31', 4, 'azkaimtiyaz', 'Azka hanif imtiyaz'),
(13, 'Yeezy', 10000000, 'sepatu bagus', 'product_img/4_Sepatu_Mahal.jpg', '2016-10-08 13:19:42', 11, 'kyloren77', 'Kylo Ren'),
(17, 'Kalung Impor', 300000, 'Kalung impor asli Indonesia', 'product_img/5_Kalung_impor.jpg', '2016-10-08 16:21:28', 11, 'kyloren77', 'Kylo Ren');

-- --------------------------------------------------------

--
-- Table structure for table `purchase`
--

CREATE TABLE `purchase` (
  `purchase_id` int(15) NOT NULL,
  `product_name` varchar(30) NOT NULL,
  `product_price` int(12) NOT NULL,
  `quantity` int(4) NOT NULL,
  `product_image` varchar(40) NOT NULL,
  `seller_id` int(15) NOT NULL,
  `buyer_id` int(15) NOT NULL,
  `product_id` int(15) NOT NULL,
  `buyer_name` varchar(30) NOT NULL,
  `buyer_address` text NOT NULL,
  `postal_code` int(5) NOT NULL,
  `phone_number` varchar(12) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `purchase`
--

INSERT INTO `purchase` (`purchase_id`, `product_name`, `product_price`, `quantity`, `product_image`, `seller_id`, `buyer_id`, `product_id`, `buyer_name`, `buyer_address`, `postal_code`, `phone_number`, `date`) VALUES
(1, 'Baju Baru', 300000, 2, 'product_img/1_Baju_Baru.jpg', 1, 0, 5, 'Ali Akbar', 'Jl Setiabudhi no 105 K', 14045, '0812812386', '2016-10-08 05:56:20'),
(2, 'Baju lama', 10000, 10, 'product_img/2_Baju_lama.jpg', 0, 4, 6, 'Azka hanif imtiyaz', 'Jl gurame Raya No 44 Sebantengan', 50512, '2147483647', '2016-10-08 06:38:48'),
(3, 'Baju Bagus', 50000, 7, 'product_img/3_Baju_Bagus.jpg', 4, 4, 7, 'Azka hanif imtiyaz', 'Jl gurame Raya No 44 Sebantengan', 50512, '2147483647', '2016-10-08 06:42:02'),
(4, 'Baju Baru', 300000, 3, 'product_img/1_Baju_Baru.jpg', 1, 11, 5, 'Kylo Ren', 'Jalan Tamansari nomor 33. Bandung', 12345, '087722031753', '2016-10-08 11:33:23'),
(5, 'Baju Baru', 300000, 1, 'product_img/1_Baju_Baru.jpg', 1, 11, 5, 'Mia', 'Jalan Tamansari nomor 49.. Bandung', 12345, '085366038991', '2016-10-08 11:35:26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `purchase`
--
ALTER TABLE `purchase`
  ADD PRIMARY KEY (`purchase_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `purchase`
--
ALTER TABLE `purchase`
  MODIFY `purchase_id` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
