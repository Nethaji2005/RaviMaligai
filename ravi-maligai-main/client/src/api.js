import axios from 'axios';

// Get API URL from environment variables
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:4000';
const BASE_URL = `${API_URL}/api`;

console.log(`🔗 API Base URL: ${BASE_URL}`);
console.log(`🔗 Full API URL: ${API_URL}`);

// Create axios instance with base URL
const apiClient = axios.create({
  baseURL: BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true, // Include cookies if using sessions
  timeout: 10000, // 10 second timeout
});

// Add request interceptor for debugging
apiClient.interceptors.request.use(
  (config) => {
    console.log(`📤 API Request: ${config.method.toUpperCase()} ${config.url}`);
    return config;
  },
  (error) => {
    console.error('❌ Request Error:', error);
    return Promise.reject(error);
  }
);

// Add response interceptor for debugging
apiClient.interceptors.response.use(
  (response) => {
    console.log(`📥 API Response: ${response.status} from ${response.config.url}`);
    return response;
  },
  (error) => {
    console.error('❌ Response Error:', error);
    return Promise.reject(error);
  }
);

// Error handler utility with detailed logging
const handleError = (error) => {
  if (error.response) {
    // Server responded with error status
    console.error('❌ API Error:', {
      status: error.response.status,
      statusText: error.response.statusText,
      data: error.response.data,
      url: error.response.config?.url,
    });
    throw new Error(
      error.response.data?.error ||
      error.response.data?.message ||
      `Server Error (${error.response.status}): ${error.response.statusText}`
    );
  } else if (error.request) {
    // Request made but no response received (network error)
    console.error('❌ Network Error:', {
      message: error.message,
      url: error.config?.url,
      baseURL: error.config?.baseURL,
      timeout: error.config?.timeout,
    });
    console.error('⚠️ Troubleshooting:');
    console.error(`   1. Is backend running on ${API_URL}?`);
    console.error(`   2. Check CORS configuration on backend`);
    console.error(`   3. Check browser console for more details`);
    throw new Error(
      `Cannot connect to backend at ${API_URL}. Please ensure the backend server is running.`
    );
  } else {
    // Other errors
    console.error('❌ Error:', error.message);
    throw error;
  }
};

// ============ PRODUCTS API ============
export const products = {
  // Get all products
  getAll: async () => {
    try {
      const { data } = await apiClient.get('/products');
      return data;
    } catch (error) {
      handleError(error);
    }
  },

  // Create new product
  create: async (product) => {
    try {
      const { data } = await apiClient.post('/products', product);
      return data;
    } catch (error) {
      handleError(error);
    }
  },

  // Update product
  update: async (id, product) => {
    try {
      const { data } = await apiClient.put(`/products/${id}`, product);
      return data;
    } catch (error) {
      handleError(error);
    }
  },

  // Delete product
  delete: async (id) => {
    try {
      const { data } = await apiClient.delete(`/products/${id}`);
      return data;
    } catch (error) {
      handleError(error);
    }
  },
};

// ============ DASHBOARD API ============
export const dashboard = {
  // Get dashboard stats
  getStats: async () => {
    try {
      const { data } = await apiClient.get('/dashboard/stats');
      return data;
    } catch (error) {
      handleError(error);
    }
  },
};

// ============ CART/CHECKOUT API ============
export const cart = {
  // Checkout and create invoice
  checkout: async (items, customer) => {
    try {
      const { data } = await apiClient.post('/cart/checkout', { items, customer });
      return data;
    } catch (error) {
      handleError(error);
    }
  },
};

// ============ INVOICES API ============
export const invoices = {
  // Get invoice PDF
  getPDF: async (invoiceId) => {
    try {
      const { data } = await apiClient.get(`/invoices/${invoiceId}/pdf`, {
        responseType: 'blob',
      });
      return data;
    } catch (error) {
      handleError(error);
    }
  },
};

// ============ SALES API ============
export const sales = {
  // Get sales history
  getHistory: async (query = '', from = '', to = '') => {
    try {
      const params = {};
      if (query) params.q = query;
      if (from) params.from = from;
      if (to) params.to = to;
      
      const { data } = await apiClient.get('/sales/history', { params });
      return data;
    } catch (error) {
      handleError(error);
    }
  },
};

// ============ REPORTS API ============
export const reports = {
  // Get sales report
  getSalesReport: async (from = '', to = '', groupBy = 'day') => {
    try {
      const params = { groupBy };
      if (from) params.from = from;
      if (to) params.to = to;
      
      const { data } = await apiClient.get('/reports/sales', { params });
      return data;
    } catch (error) {
      handleError(error);
    }
  },
};

export default apiClient;
