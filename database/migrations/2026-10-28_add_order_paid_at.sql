-- Record when money is actually received so the admin revenue range follows payment date.
ALTER TABLE orders ADD COLUMN paid_at DATETIME NULL;

-- Keep existing paid orders visible in revenue reports after introducing paid_at.
UPDATE orders
SET paid_at = updated_at
WHERE payment_status = 'PAID' AND paid_at IS NULL;
