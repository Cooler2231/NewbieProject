--- STEAMODDED HEADER
--- MOD_NAME: Newbie Project
--- MOD_ID: RH
--- PREFIX: rh
--- MOD_AUTHOR: [Celeritas]
--- MOD_DESCRIPTION: New Added Jokers, Hand Types, etc.
--- VERSION: 1.1.1
----------------------------------------------
------------MOD CODE -------------------------

function get_run(hand, len1, len2)
    local ret = {}
    local minlen = math.min(len1, len2)
    local pair_list = get_X_same(minlen, hand, true)
    local _pairs = {}
    for _, v in ipairs(pair_list) do _pairs[v[1].base.value] = v end
    for _, rank in ipairs(SMODS.Rank.obj_buffer) do
        local curr = _pairs[rank]
        if curr and #curr >= len1 then
            local run = false
            for _, next_rank in ipairs(SMODS.Ranks[rank].next) do
                local other = _pairs[next_rank]
                if other and #other >= len2 then
                    for _, v in ipairs(other) do
                        table.insert(curr, v)
                    end
                    run = true
                end
            end
            if run then table.insert(ret, curr) end
        end
    end
    return ret
end

SMODS.PokerHand {
    key = 'Run',
    above_hand = 'Pair',
    chips = 15,
    mult = 3,
    l_chips = 10,
    l_mult = 2,
    example = {
        { 'S_2',    true },
        { 'C_2',    true },
        { 'H_3',    true },
        { 'C_J',    false },
        { 'D_6',    false },
    },
    loc_txt = {
        ['en-us'] = {
            name = 'Run',
            description = {
                '3 cards containing a Pair and an additional High Card',
                ' that is one rank higher than the Pairs rank.',
            }
        }
    },
atomic_part = function(hand)
  local ret = {}
  local _pairs = get_X_same(2, hand, true)
  for _, _pair in ipairs(_pairs) do
    local rank = SMODS.Ranks[_pair[1].base.value]
    local run = false
    for _, card in ipairs(hand) do
      for _, next_rank in ipairs(rank.next) do
        if card:get_id() > 0 and card.base.value == next_rank then table.insert(_pair, card); run = true end
      end
    end
    if run then table.insert(ret, _pair) end
  end
  return ret
end
}

SMODS.PokerHand {
    key = 'Run of Three',
    above_hand = 'Flush',
    chips = 35,
    mult = 6,
    l_chips = 15,
    l_mult = 3,
    example = {
        { 'S_5',    true },
        { 'C_5',    true },
        { 'H_5',    true },
        { 'D_6',    true },
        { 'H_2',    false },
    },
    loc_txt = {
        ['en-us'] = {
            name = 'Run of Three',
            description = {
                '4 cards containing a Three of a Kind and an additional High Card',
                ' that is one rank higher than the Three of a Kinds rank.',
            }
        }
    },
atomic_part = function(hand)
  local ret = {}
  local _pairs = get_X_same(3, hand, true)
  for _, _pair in ipairs(_pairs) do
    local rank = SMODS.Ranks[_pair[1].base.value]
    local run = false
    for _, card in ipairs(hand) do
      for _, next_rank in ipairs(rank.next) do
        if card:get_id() > 0 and card.base.value == next_rank then table.insert(_pair, card); run = true end
      end
    end
    if run then table.insert(ret, _pair) end
  end
  return ret
end
}

SMODS.PokerHand {
    key = 'Run House',
    above_hand = 'Full House',
    chips = 55,
    mult = 5,
    l_chips = 20,
    l_mult = 4,
    example = {
        { 'S_T',    true },
        { 'C_T',    true },
        { 'H_T',    true },
        { 'D_J',    true },
        { 'H_J',    true },
    },
    loc_txt = {
        ['en-us'] = {
            name = 'Run House',
            description = {
                'A Full House that requires the pair after the Three of a Kind',
                ' to only include ranks one higher than the Three of a Kind.',
            }
        }
    },
atomic_part = function(hand) return get_run(hand, 3, 2)
end
}

SMODS.PokerHand {
    key = 'Run of Four',
    above_hand = 'Four of a Kind',
    chips = 80,
    mult = 8,
    l_chips = 30,
    l_mult = 4,
    example = {
        { 'S_J',    true },
        { 'D_J',    true },
        { 'H_J',    true },
        { 'C_J',    true },
        { 'D_Q',    true },
    },
    loc_txt = {
        ['en-us'] = {
            name = 'Run of Four',
            description = {
                'A Four of a Kind with an additional High Card',
                ' that is one rank higher than the rank of the Four of a Kind.',
            }
        }
    },
atomic_part = function(hand)
  local ret = {}
  local _pairs = get_X_same(4, hand, true)
  for _, _pair in ipairs(_pairs) do
    local rank = SMODS.Ranks[_pair[1].base.value]
    local run = false
    for _, card in ipairs(hand) do
      for _, next_rank in ipairs(rank.next) do
        if card:get_id() > 0 and card.base.value == next_rank then table.insert(_pair, card); run = true end
      end
    end
    if run then table.insert(ret, _pair) end
  end
  return ret
end
}

SMODS.Atlas { key = 'atlasplanets', path = 'atlasplanets.png', px = 71, py = 95 }

SMODS.Consumable {
    set = 'Planet',
    key = 'moon',
    config = { hand_type = 'h_rh_Run' },
    pos = {x = 0, y = 0 },
    atlas = 'atlasplanets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        ['en-us'] = {
            name = 'Moon'
        }
    }
}

SMODS.Consumable {
    set = 'Planet',
    key = 'titan',
    config = { hand_type = 'h_rh_Run of Three' },
    pos = {x = 1, y = 0 },
    atlas = 'atlasplanets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        ['en-us'] = {
            name = 'Titan'
        }
    }
}

SMODS.Consumable {
    set = 'Planet',
    key = 'enceladus',
    config = { hand_type = 'h_rh_Run House' },
    pos = {x = 2, y = 0 },
    atlas = 'atlasplanets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        ['en-us'] = {
            name = 'Enceladus'
        }
    }
}

SMODS.Consumable {
    set = 'Planet',
    key = 'io',
    config = { hand_type = 'h_rh_Run of Four' },
    pos = {x = 3, y = 0 },
    atlas = 'atlasplanets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        ['en-us'] = {
            name = 'Io'
        }
    }
}

SMODS.Consumable {
    set = 'Planet',
    key = 'titan',
    config = { hand_type = 'h_rh_Run Of Three' },
    pos = {x = 2, y = 0 },
    atlas = 'atlasplanets',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        ['en-us'] = {
            name = 'Titan'
        }
    }
}

SMODS.Atlas { key = 'thesprint', path = 'thesprint.png', px = 69, py = 93 }

SMODS.Joker {
    key = 'sprint',
    name = "The Sprint",
    loc_txt = {
        name = "The Sprint",
        text = {
            "{X:mult,C:white}X2# {} Mult if played hand",
            "contains a {C:attention}Run{}."
        },
        unlock = {
            "Win a run",
            "without playing",
            "a {C:attention}Run{}."
        }
    },
    rarity = 3,
    atlas = 'thesprint',
    pos = {x = 0, y = 0},
    cost = 8,
    blueprint_compat = true,
    config = {
     Xmult = 2,
     type = 'h_rh_Run'
    },
    unlock_condition = {type = 'win_no_hand', extra = 'Run'},
    unlocked = false,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.x_mult, localize(card.ability.type, 'poker_hands')}
        }
    end
}

SMODS.Atlas { key = 'thedash', path = 'thedash.png', px = 69, py = 93 }

SMODS.Joker {
    key = 'dash',
    name = "The Dash",
    loc_txt = {
        name = "The Dash",
        text = {
            "{X:mult,C:white}X3# {} Mult if played hand",
            "contains a {C:attention}Run of Three{}."
        },
        unlock = {
            "Win a run",
            "without playing",
            "a {C:attention}Run of Three{}."
        }
    },
    rarity = 3,
    atlas = 'thedash',
    pos = {x = 0, y = 0},
    cost = 8,
    blueprint_compat = true,
    config = {
     Xmult = 3,
     type = 'h_rh_Run of Three'
    },
    unlock_condition = {type = 'win_no_hand', extra = 'Run of Three'},
    unlocked = false,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.x_mult, localize(card.ability.type, 'poker_hands')}
        }
    end
}