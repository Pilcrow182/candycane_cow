--------------
-- Settings --
--------------

ENABLE_SPAWNER  = true
REPLACE_NYANCAT = true
REPLACE_PBJ_DOG = true


-----------
-- Nodes --
-----------

minetest.register_node("candycane_cow:cow", {
	description = "Candycane Cow",
	tiles = {
		"candycane_cow_sides.png",
		"candycane_cow_udder.png",
		"candycane_cow_sides.png",
		"candycane_cow_sides.png",
		"candycane_cow_butt.png",
		"candycane_cow_face.png"
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	legacy_facedir_simple = true,
	sounds = default.node_sound_defaults(),
})

minetest.register_node("candycane_cow:candy", {
	description = "Candycane",
	tiles = {
		"candycane_cow_candy.png^[transformR90",
		"candycane_cow_candy.png^[transformR90",
		"candycane_cow_candy.png"
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})


------------
-- Crafts --
------------

minetest.register_craft({
	type = "fuel",
	recipe = "candycane_cow:cow",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "candycane_cow:candy",
	burntime = 1,
})


----------
-- ABMs --
----------

if ENABLE_SPAWNER then
	minetest.register_on_generated(function(minp, maxp, seed)
		local height_min = -31000
		local height_max = -32
		local chance = 1000

		if maxp.y < height_min or minp.y > height_max then
			return
		end

		local y_min = math.max(minp.y, height_min)
		local y_max = math.min(maxp.y, height_max)
		local pr = PseudoRandom(seed + 9324342)

		if pr:next(0, chance) == 0 then

			local x0 = pr:next(minp.x, maxp.x)
			local y0 = pr:next(minp.y, maxp.y)
			local z0 = pr:next(minp.z, maxp.z)
			local p0 = {x = x0, y = y0, z = z0}

			local pos, facedir, length = p0, pr:next(0, 3), pr:next(3, 15)

			if facedir > 3 then
				facedir = 0
			end

			local tailvec = minetest.facedir_to_dir(facedir)
			local p = {x = pos.x, y = pos.y, z = pos.z}

			minetest.set_node(p, {name = "candycane_cow:cow", param2 = facedir})

			for i = 1, length do
				p.x = p.x + tailvec.x
				p.z = p.z + tailvec.z
				minetest.set_node(p, {name = "candycane_cow:candy", param2 = facedir})
			end
		end
	end)
end


-------------
-- Aliases --
-------------

if REPLACE_NYANCAT then
	minetest.register_alias("default:nyancat", "candycane_cow:cow")
	minetest.register_alias("default:nyancat_rainbow", "candycane_cow:candy")

	minetest.register_alias("nyancat", "candycane_cow:cow")
	minetest.register_alias("nyancat_rainbow", "candycane_cow:cow")

	default.make_nyancat = place_cow
end

if REPLACE_PBJ_DOG then
	minetest.register_alias("pbj_pup:pbj_pup", "candycane_cow:cow")
	minetest.register_alias("pbj_pup:pbj_pup_candies", "candycane_cow:candy")
end
