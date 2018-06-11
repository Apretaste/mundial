-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Servidor: 10.0.0.5:3306
-- Tiempo de generación: 11-06-2018 a las 00:55:15
-- Versión del servidor: 5.7.22-0ubuntu0.16.04.1
-- Versión de PHP: 7.0.30-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `apretaste`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `_mundial_bets`
--

CREATE TABLE `_mundial_bets` (
  `id` int(11) NOT NULL,
  `user` varchar(30) NOT NULL,
  `match` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `team` varchar(30) NOT NULL,
  `amount` float NOT NULL,
  `active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `_mundial_bets`
--
ALTER TABLE `_mundial_bets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `match` (`match`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `_mundial_bets`
--
ALTER TABLE `_mundial_bets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `_mundial_bets`
--
ALTER TABLE `_mundial_bets`
  ADD CONSTRAINT `_mundial_bets_ibfk_1` FOREIGN KEY (`match`) REFERENCES `_mundial_matches` (`start_date`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
