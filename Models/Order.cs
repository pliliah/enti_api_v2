using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace enti_api.Models
{
    public class Order
    {
        public List<OrderItem> shoppingCart { get; set; }
        public Customer customer { get; set; }
    }
    
    public class OrderItem
    {
        public ShoppingItem item { get; set; }
        public int quantity { get; set; }
    }

    public class Orders
    {
        public int orderId { get; set; }
        public int customerId { get; set; }
        public int shoppingCartId { get; set; }
        public string message { get; set; }
        public bool isCompleted { get; set; }
        public DateTime orderDate { get; set; }
        public DateTime? orderCompletedDate { get; set; }
        public int itemsCount { get; set; }
        public double totalPrice { get; set; }
    }

    public class OrderDetails
    {
        public int orderId { get; set; }
        public int shoppingCartId { get; set; }
        public int customerId { get; set; }
        public bool isCompleted { get; set; }
        public DateTime orderDate { get; set; }
        public DateTime? orderCompletedDate { get; set; }
        public Customer customer { get; set; }
        public List<OrderItem> items{ get; set; }

        public class OrderItem
        {
            public int shoppingItemId { get; set; }
            public int quantity { get; set; }
            public double sellPrice { get; set; }
            public string title { get; set; }
            public double itemPrice { get; set; }
            public int discount { get; set; }
            public string categoryName { get; set; }
            public string imageSrc { get; set; }
        }
    }
}