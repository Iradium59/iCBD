INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_cbd','CBD',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_cbd','CBD',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_cbd', 'CBD', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('cbd', 'CBD');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('cbd', 0, 'recrue','Vendeur', 200, 'null', 'null'),
('cbd', 1, 'chef','Commercial', 300, 'null', 'null'),
('cbd', 2, 'boss', 'Directeur', 400, 'null', 'null');

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('cbd', 'CBD', 1, 0, 0),
('splif', 'Splif', 1, 0, 0);
