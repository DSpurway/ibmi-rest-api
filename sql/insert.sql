INSERT INTO CLAIMS/POLICY (policyID, firstName, lastName, street1, street2, city, state, zip, email, phone)
VALUES  ('823M934A', 'Nadir', 'Amra', '123 East Rd', 'Apt. 902', 'San Fransisco', 'CA', '44567', 'nadir.amra@xyz.com', '(999)999-999'),
        ('826M660F', 'John', 'Doe', '4567 Farm to Market Rd', '', 'Leander', 'TX', '78632', 'john_doe@xyz.com', '(512)999-9999'),
        ('747F023X', 'Jane', 'Deaux', '9876 Short St', 'Unit 543', 'Poughkeepsie', 'NY', '12524', 'jane.deaux@xyz.com', '(845)999-9999');

INSERT INTO CLAIMS/VEHICLE (vehicleID, makeYear, make, model, vin, policyID)
VALUES  ('ASDF1234', 2023, 'Toyota', 'Camry', 'JDL390DJIDJIFJFIE', '823M934A'),
        ('XC092144', 2018, 'Nissan', 'Altima', '9EMC83KJD9EKD9K1D', '823M934A'),
        ('U9MQ0DMW', 2008, 'Ford', 'Mustang', 'DJIDJIFJ629203FIE', '826M660F'),
        ('ASUIW204', 2005, 'Chevrolet', 'Corvette', 'G9730JQI292JGTY72', '826M660F'),
        ('02020DF4', 2022, 'Dodge', 'Challenger', 'K30B4DPE8890XQNB8', '826M660F'),
        ('9JMN3DR6', 1987, 'Chevrolet', 'Monte Carlo SS', 'JP72NE80S150FD84U', '826M660F'),
        ('YW93MQRJ', 2023, 'Jeep', 'Wrangler', 'DJ92888KIDJIFJFIE', '747F023X'),
        ('0PK398H2', 2004, 'Ford', 'Focus', 'RG82MN02DS80PE92J', '747F023X'),
        ('9380S88J', 1989, 'Buick', 'Grand National', 'QWERTY83046KI9K30', '747F023X');
