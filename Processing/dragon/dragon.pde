// 
// This program by JMJ is a request by KAJ in August 2020, for findng the best set
// of purchases in DragonVale.
//
// Computes the selection of items that maximizes the cost of all items purchased,
// but makes sure that this cost is less than or equal to available coins.
// Set the {items} array to the items you want to purchase and their cost.
// Set {coins} to the amount of money you have.
// Algorithm: brute force checking all 2^n-1 possible combinations of one or more
// items.

static class Item {
  public Item(String n, int c) {
    name = n; 
    cost = c;
  }
  public final String name;
  public final int cost;
}

public static void main(String[] args) {
  int coins = 100; // How much money you have.

  Item[] items = {
    new Item("red", 10), 
    new Item("blue", 20), 
    new Item("yellow", 20), 
  };
  int bits = find_optimal_picks(items, coins);
  print_picked_items(items, bits);
}

// Find the optimal set of items to pick that maximizes
// amount spent
static int find_optimal_picks(Item[] items, int coins) {

  // If length is 4, want to generate binary pattern 0001, 0010, 0011, 0100, ...., 1111
  // (that is 15 patterns, or 2^4 - 1.
  int N = (1 << items.length) - 1; // that's 2^items.length - 1.
  int best_bits = 0;
  int best_cost = 0;
  for (int bits = 1; bits <= N; bits++) {
    int cost = picked_items_cost(items, bits);
    // Best cost is the highest cost that is <= to coins.
    if (cost <= coins && best_cost < cost) {
      best_bits = bits;
      best_cost = cost;
    }
  }
  return best_bits;
}

// Select the items based on the bit pattern {bits}.
// LSB bit refers to item[0]
static int picked_items_cost(Item[] items, int bits) {
  int total_cost = 0;
  for (Item it : items) {
    if (bits == 0) {
      break; // no remaining bits are set to 1.
    }
    if (bits % 2 == 1) {
      total_cost += it.cost;
    }
    bits /= 2;
  }
  return total_cost;
}


// Print only selected items, and the total cost
// of the selected items.
static void print_picked_items(Item[] items, int bits) {
  boolean onePicked = false;
  int total = 0;
  for (Item it : items) {
    if (bits % 2 == 1) {
      println(it.name + ": " + it.cost);
      onePicked = true;
      total += it.cost;
    }
    bits /= 2;
  }
  if (!onePicked) {
    println("None picked!");
  } else {
    println("total cost: " + total);
  }
}
