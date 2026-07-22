import { useEffect, useMemo, useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import DashboardLayout from '../components/DashboardLayout'
import Card from '../components/Card'
import SearchBar from '../components/SearchBar'
import RiskBadge from '../components/RiskBadge'
import DataTable from '../components/DataTable'
import patientService from '../services/patientService'
import { formatDate } from '../utils/formatters'

export default function Patients() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [search, setSearch] = useState(searchParams.get('search') || '')
  const [village, setVillage] = useState('All')
  const [riskLevel, setRiskLevel] = useState('All')
  const [trimester, setTrimester] = useState('All')
  const [sortOrder, setSortOrder] = useState('latest')

  const [patients, setPatients] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    patientService
      .getAllPatients()
      // Normalize the human-readable patientId onto `id` so the rest of this
      // page (columns, row keys, navigation) can stay exactly as it was.
      .then((data) => setPatients(data.map((p) => ({ ...p, id: p.patientId }))))
      .finally(() => setLoading(false))
  }, [])

  const villageList = useMemo(() => [...new Set(patients.map((p) => p.village))].sort(), [patients])

  const filtered = useMemo(() => {
    let result = [...patients]

    if (search.trim()) {
      const q = search.toLowerCase()
      result = result.filter((p) => p.name.toLowerCase().includes(q) || p.id.toLowerCase().includes(q))
    }
    if (village !== 'All') result = result.filter((p) => p.village === village)
    if (riskLevel !== 'All') result = result.filter((p) => p.risk === riskLevel)
    if (trimester !== 'All') result = result.filter((p) => String(p.trimester) === trimester)

    if (sortOrder === 'latest') {
      result.sort((a, b) => new Date(b.lastVisit) - new Date(a.lastVisit))
    } else {
      result.sort((a, b) => new Date(a.lastVisit) - new Date(b.lastVisit))
    }
    return result
  }, [patients, search, village, riskLevel, trimester, sortOrder])

  const columns = useMemo(
    () => [
      { Header: 'Patient ID', accessor: 'id' },
      { Header: 'Name', accessor: 'name' },
      { Header: 'Age', accessor: 'age' },
      { Header: 'Village', accessor: 'village' },
      { Header: 'Trimester', accessor: 'trimester', Cell: ({ value }) => `T${value}` },
      { Header: 'Risk', accessor: 'risk', Cell: ({ value }) => <RiskBadge risk={value} size="sm" /> },
      { Header: 'Last Visit', accessor: 'lastVisit', Cell: ({ value }) => formatDate(value) },
      {
        Header: 'Actions',
        accessor: 'actions',
        disableSortBy: true,
        Cell: ({ row }) => (
          <div className="flex items-center gap-3">
            <button
              onClick={() => navigate(`/patients/${row.original.id}`)}
              className="text-xs font-semibold text-primary-600 hover:text-primary-700"
            >
              View
            </button>
            <button
              onClick={() => navigate(`/patients/${row.original.id}`)}
              className="text-xs font-semibold text-ink-700 hover:text-ink-900"
            >
              Edit
            </button>
          </div>
        ),
      },
    ],
    [navigate]
  )

  return (
    <DashboardLayout>
      <div className="mb-6">
        <h1 className="font-display text-2xl font-bold text-ink-900">Patients</h1>
        <p className="text-sm text-ink-500 mt-1">{filtered.length} of {patients.length} patients shown</p>
      </div>

      <Card className="p-5 mb-5">
        <div className="flex flex-wrap gap-3">
          <SearchBar value={search} onChange={setSearch} placeholder="Search by name or patient ID..." />

          <select
            value={village}
            onChange={(e) => setVillage(e.target.value)}
            className="px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
          >
            <option value="All">All Villages</option>
            {villageList.map((v) => <option key={v} value={v}>{v}</option>)}
          </select>

          <select
            value={riskLevel}
            onChange={(e) => setRiskLevel(e.target.value)}
            className="px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
          >
            <option value="All">All Risk Levels</option>
            <option value="Normal">Normal</option>
            <option value="Medium">Medium</option>
            <option value="High">High</option>
          </select>

          <select
            value={trimester}
            onChange={(e) => setTrimester(e.target.value)}
            className="px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
          >
            <option value="All">All Trimesters</option>
            <option value="1">Trimester 1</option>
            <option value="2">Trimester 2</option>
            <option value="3">Trimester 3</option>
          </select>

          <select
            value={sortOrder}
            onChange={(e) => setSortOrder(e.target.value)}
            className="px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
          >
            <option value="latest">Latest Visit</option>
            <option value="oldest">Oldest Visit</option>
          </select>
        </div>
      </Card>

      <Card className="p-5">
        {loading ? (
          <p className="text-sm text-ink-500 py-6 text-center">Loading patients...</p>
        ) : (
          <DataTable columns={columns} data={filtered} pageSize={8} />
        )}
      </Card>
    </DashboardLayout>
  )
}
