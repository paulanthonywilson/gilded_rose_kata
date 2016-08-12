class ItemUpdater
  def initialize(item)
    @item = item
  end

  def update
    update_quality
    update_sell_in
  end

  def update_quality
    if (@item.sell_in < 1)
      update_quality_after_sell_in
    else
      update_quality_before_sell_in
    end
  end

  def update_sell_in
    @item.sell_in -= 1
  end

  def reduce_quality(by)
    @item.quality = [@item.quality - by, 0].max
  end

  def increase_quality(by)
    @item.quality = [@item.quality + by, 50].min
  end
end

class NormalUpdater < ItemUpdater
  def update_quality_before_sell_in
    reduce_quality(1)
  end

  def update_quality_after_sell_in
    reduce_quality(2)
  end
end

class AgedBrieUpdater < ItemUpdater
  def update_quality_before_sell_in
    increase_quality(1)
  end

  def update_quality_after_sell_in
    increase_quality(2)
  end
end

class BackStageUpdater < ItemUpdater
  def update_quality_before_sell_in
    if @item.sell_in < 6
      increase_quality(3)
    elsif @item.sell_in < 11
      increase_quality(2)
    else
      increase_quality(1)
    end
  end

  def update_quality_after_sell_in
    @item.quality = 0
  end
end

class SulfurasUpdater < ItemUpdater
  def update_quality
  end

  def update_sell_in
  end
end

class ConjuredItemUpdater < ItemUpdater
  def update_quality_before_sell_in
    reduce_quality(2)
  end

  def update_quality_after_sell_in
    reduce_quality(4)
  end
end

def updater_for(item)
  case item.name
  when 'Aged Brie' then AgedBrieUpdater.new(item)
  when 'Backstage passes to a TAFKAL80ETC concert' then BackStageUpdater.new(item)
  when 'Sulfuras, Hand of Ragnaros' then SulfurasUpdater.new(item)
  when 'Conjured Mana Cake' then ConjuredItemUpdater.new(item)
  else NormalUpdater.new(item)
  end
end

def update_quality(items)
  items.each { |item|
    updater = updater_for(item).update
  }
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

