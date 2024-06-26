CREATE INDEX idx_properties_type_city_price_available
ON properties (type, address_id, price, is_available);

CREATE INDEX idx_properties_type ON properties (type);
DROP INDEX idx_properties_type;
CREATE INDEX idx_photoes_property_id_order ON photoes (property_id, "order");

CREATE INDEX idx_bookings_user_id ON bookings (user_id);

CREATE INDEX idx_bookings_property_id ON bookings (property_id);

CREATE INDEX idx_ratings_property_id ON ratings (property_id);

CREATE INDEX idx_addresses_duplicate_check
ON addresses (street_title, street_address, apartment_number);



SELECT * from properties
WHERE TYPE ='house'