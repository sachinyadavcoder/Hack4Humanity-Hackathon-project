import { useTable, usePagination, useSortBy } from 'react-table'
import { useMemo } from 'react'

export default function DataTable({ columns, data, pageSize = 8 }) {
  const memoColumns = useMemo(() => columns, [columns])
  const memoData = useMemo(() => data, [data])

  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    prepareRow,
    page,
    canPreviousPage,
    canNextPage,
    pageOptions,
    gotoPage,
    nextPage,
    previousPage,
    state: { pageIndex },
  } = useTable(
    {
      columns: memoColumns,
      data: memoData,
      initialState: { pageIndex: 0, pageSize },
    },
    useSortBy,
    usePagination
  )

  return (
    <div>
      <div className="overflow-x-auto -mx-5 px-5">
        <table {...getTableProps()} className="w-full text-sm min-w-[760px]">
          <thead>
            {headerGroups.map((headerGroup) => {
              const { key, ...restHeaderGroupProps } = headerGroup.getHeaderGroupProps()
              return (
                <tr key={key} {...restHeaderGroupProps}>
                  {headerGroup.headers.map((column) => {
                    const { key: colKey, ...restColProps } = column.getHeaderProps(column.getSortByToggleProps())
                    return (
                      <th
                        key={colKey}
                        {...restColProps}
                        className="text-left text-xs font-semibold text-ink-500 uppercase tracking-wide pb-3 pr-4 border-b border-surface-border cursor-pointer select-none whitespace-nowrap"
                      >
                        <span className="inline-flex items-center gap-1">
                          {column.render('Header')}
                          {column.isSorted ? (column.isSortedDesc ? ' ↓' : ' ↑') : ''}
                        </span>
                      </th>
                    )
                  })}
                </tr>
              )
            })}
          </thead>
          <tbody {...getTableBodyProps()}>
            {page.map((row) => {
              prepareRow(row)
              const { key, ...restRowProps } = row.getRowProps()
              return (
                <tr key={key} {...restRowProps} className="border-b border-surface-border last:border-0 hover:bg-surface-bg/60">
                  {row.cells.map((cell) => {
                    const { key: cellKey, ...restCellProps } = cell.getCellProps()
                    return (
                      <td key={cellKey} {...restCellProps} className="py-3 pr-4 text-ink-700 whitespace-nowrap">
                        {cell.render('Cell')}
                      </td>
                    )
                  })}
                </tr>
              )
            })}
            {page.length === 0 && (
              <tr>
                <td colSpan={memoColumns.length} className="py-10 text-center text-ink-500 text-sm">
                  No records match your filters.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {pageOptions.length > 1 && (
        <div className="flex items-center justify-between pt-4 mt-1 border-t border-surface-border text-sm">
          <span className="text-ink-500">
            Page {pageIndex + 1} of {pageOptions.length}
          </span>
          <div className="flex gap-2">
            <button
              onClick={() => gotoPage(0)}
              disabled={!canPreviousPage}
              className="px-2.5 py-1.5 rounded-lg border border-surface-border text-ink-700 disabled:opacity-40 hover:bg-surface-bg"
            >
              «
            </button>
            <button
              onClick={previousPage}
              disabled={!canPreviousPage}
              className="px-3 py-1.5 rounded-lg border border-surface-border text-ink-700 disabled:opacity-40 hover:bg-surface-bg"
            >
              Prev
            </button>
            <button
              onClick={nextPage}
              disabled={!canNextPage}
              className="px-3 py-1.5 rounded-lg border border-surface-border text-ink-700 disabled:opacity-40 hover:bg-surface-bg"
            >
              Next
            </button>
            <button
              onClick={() => gotoPage(pageOptions.length - 1)}
              disabled={!canNextPage}
              className="px-2.5 py-1.5 rounded-lg border border-surface-border text-ink-700 disabled:opacity-40 hover:bg-surface-bg"
            >
              »
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
