import routes from 'constants/routes.json';

export const adminRoutes = [
  {
    as: 'Link',
    key: 'dashboard',
    to: routes.DASHBOARD,
    content: 'Dashboard',
  },
  {
    as: 'Link',
    key: 'privacy',
    to: routes.PRIVACY,
    content: 'Privacy Tools',
  },
  {
    as: 'Link',
    key: 'register',
    to: routes.REGISTER,
    content: 'Register System',
  },
  {
    as: 'Link',
    key: 'disposal',
    to: routes.DISPOSAL,
    content: 'Disposal',
  },
  {
    as: 'Link',
    key: 'consumer',
    to: routes.CONSUMER,
    content: 'Consumer Request',
  },
  {
    as: 'Link',
    key: 'users',
    to: routes.USERS,
    content: 'Users',
  },
  {
    as: 'Link',
    key: 'setting',
    to: routes.SETTING,
    content: 'Setting',
  },
  {
    as: 'Link',
    key: 'resources',
    to: routes.RESOURCES,
    content: 'Resources',
  },
];
