import type { PageServerLoad } from "./$types";

const PB_URL =
  process.env.POCKETBASE_URL ||
  "https://pocketbase-production-4cba.up.railway.app";

export const load: PageServerLoad = async ({ fetch, url }) => {
  const page = parseInt(url.searchParams.get("page") || "1");
  const typeFilter = url.searchParams.get("type") || "";
  const perPage = 30;

  let filter = "";
  if (typeFilter) {
    filter = `&filter=(type='${typeFilter}')`;
  }

  let events: unknown[] = [];
  let totalPages = 1;
  let totalItems = 0;

  try {
    const res = await fetch(
      `${PB_URL}/api/collections/events/records?sort=-created&page=${page}&perPage=${perPage}${filter}`
    );
    if (res.ok) {
      const data = await res.json();
      events = data.items || [];
      totalPages = data.totalPages || 1;
      totalItems = data.totalItems || 0;
    }
  } catch {
    // PocketBase down
  }

  return {
    events,
    page,
    totalPages,
    totalItems,
    typeFilter,
  };
};
