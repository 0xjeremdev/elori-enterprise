/**
 * Accepts a string of the form `2020-01-31T00:00:00.000000Z`.
 * Returns a string of the form `2020-01-31`.
 */
export const trimDateString = (dateStr) => {
  if (!dateStr) return '';
  const T = dateStr.indexOf('T');
  return T === -1 ? dateStr : dateStr.substring(0, T);
};

/**
 * Accepts a string of the form `2020-01-31T04:12:00.000000Z`.
 * Returns a string of the form `04:12 AM`.
 */
export const trimLocalTimeString = (dateStr) => {
  if (!dateStr) return '';
  const dateTime = new Date(dateStr);
  return dateTime.toLocaleTimeString();
};

/**
 * Accepts a string of the form `Wed Jan 31 2020 16:40:52 GMT-0600 (Mount`.
 * Returns a string of the form `Wed Jan 31 2020`.
 */
export const formatDate = (timestamp) => {
  let date = null;
  let tempDate = null;
  let stamp = '';
  stamp = timestamp.toString();
  tempDate = stamp.split(' ');
  const [weekday, month, day, year, time, offset, timezone] = tempDate;
  date = `${weekday} ${month} ${day} ${year}`;
  return date;
};
