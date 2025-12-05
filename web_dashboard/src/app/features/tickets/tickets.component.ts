import { Component, computed, signal } from '@angular/core';
import { DatePipe, NgClass, NgFor, NgIf } from '@angular/common';
import { FormsModule } from '@angular/forms';

type Priority = 'High' | 'Medium' | 'Low';

interface Ticket {
  id: string;
  subject: string;
  assignee: string;
  avatar: string;
  user: string;
  status: 'Open' | 'Resolved' | 'In Progress' | 'Failed';
  priority: Priority;
  open: boolean;
  createdAt: string;
}

@Component({
  selector: 'app-tickets',
  standalone: true,
  imports: [NgFor, NgIf, NgClass, DatePipe, FormsModule],
  template: `
    <div class="space-y-4 w-full tickets-shell">
      <header class="space-y-2">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400">Module</p>
            <h2 class="text-2xl font-semibold text-slate-100">Tickets</h2>
            <p class="text-slate-400 text-sm">Manage tickets and track performance</p>
          </div>
        </div>
      </header>

      <div class="panel-body">
        <div class="filter-row w-full">
          <button
            *ngFor="let card of cardFilters"
            type="button"
            (click)="activeTab.set(card.value)"
            [ngClass]="['filter-pill', activeTab() === card.value ? 'filter-pill-active' : '']"
          >
            <span class="filter-label">{{ card.label }}</span>
            <span class="filter-value">{{ card.count() }}</span>
          </button>
        </div>

        <div class="scroll-pane">
          <div class="table-wrapper table-view surface-panel w-full table-shell">
            <table class="w-full table-auto divide-y divide-white/5 table-fill">
              <thead class="bg-white/5 text-[12px] uppercase tracking-wide text-slate-300">
                <tr>
                  <th class="px-4 py-3 text-left">Ticket ID</th>
                  <th class="px-4 py-3 text-left">Subject</th>
                  <th class="px-4 py-3 text-left cursor-pointer select-none" (click)="toggleSort()">
                    <span class="inline-flex items-center gap-1">
                      Created
                      <span class="text-[10px] opacity-70">{{ sortDir() === 'asc' ? '↑' : '↓' }}</span>
                    </span>
                  </th>
                  <th class="px-4 py-3 text-left">Assignee</th>
                  <th class="px-4 py-3 text-left">Status</th>
                  <th class="px-4 py-3 text-left">Priority</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-white/5 text-sm text-slate-100">
                <tr
                  *ngFor="let ticket of displayTickets(); let i = index"
                  [ngClass]="[
                    i % 2 === 0 ? 'bg-slate-950/40' : 'bg-slate-900/40',
                    'row-frame'
                  ]"
                  class="transition hover:bg-white/10"
                >
                  <td class="px-4 py-3 font-semibold text-slate-100">{{ ticket.id }}</td>
                  <td class="px-4 py-3">
                    <div class="font-semibold">{{ ticket.subject }}</div>
                  </td>
                  <td class="px-4 py-3 text-slate-200 text-sm">{{ ticket.createdAt | date: 'MMM d, y' }}</td>
                  <td class="px-4 py-3">
                    <span class="text-slate-100 font-medium">{{ ticket.assignee }}</span>
                  </td>
                  <td class="px-4 py-3">
                    <span class="pill status-pill" [ngClass]="statusBadgeClass(ticket.status)">{{ ticket.status }}</span>
                  </td>
                  <td class="px-4 py-3">
                    <span class="pill priority-pill" [ngClass]="priorityBadgeClass(ticket.priority)">
                      <span class="h-2 w-2 rounded-full" [ngClass]="priorityDotClass(ticket.priority)"></span>
                      {{ ticket.priority }}
                    </span>
                  </td>
                </tr>
                <tr *ngIf="!filteredTickets().length">
                  <td colspan="5" class="px-4 py-6 text-center text-slate-400">No tickets match this filter.</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="card-view space-y-3">
            <div
              *ngFor="let ticket of displayTickets(); let i = index"
              class="ticket-card surface-panel"
              [ngClass]="i % 2 === 0 ? 'card-a' : 'card-b'"
            >
              <div class="card-header">
                <span class="card-id">{{ ticket.id }}</span>
                <span class="card-date">{{ ticket.createdAt | date: 'MMM d, y' }}</span>
              </div>
              <div class="card-subject">{{ ticket.subject }}</div>
              <div class="card-meta">
                <div class="pill status-pill" [ngClass]="statusBadgeClass(ticket.status)">{{ ticket.status }}</div>
                <div class="pill priority" [ngClass]="priorityBadgeClass(ticket.priority)">
                  <span class="dot" [ngClass]="priorityDotClass(ticket.priority)"></span>
                  {{ ticket.priority }}
                </div>
                <div class="assignee">{{ ticket.assignee || 'Unassigned' }}</div>
              </div>
            </div>
            <div *ngIf="!filteredTickets().length" class="text-slate-400 text-center py-4 text-sm">No tickets match this filter.</div>
          </div>
        </div>
      </div>
    </div>
  `
  ,
  styleUrls: ['./tickets.component.scss']
})
export class TicketsComponent {
  readonly cardFilters = [
    { label: 'All', value: 'All' as const, count: () => this.tickets().length },
    { label: 'Open', value: 'Open' as const, count: () => this.countStatus('Open') },
    { label: 'In Progress', value: 'In Progress' as const, count: () => this.countStatus('In Progress') },
    { label: 'Resolved', value: 'Resolved' as const, count: () => this.countStatus('Resolved') },
    { label: 'Unassigned', value: 'Unassigned' as const, count: () => this.unassignedCount() }
  ];

  private readonly tickets = signal<Ticket[]>([
    {
      id: '#59678',
      subject: 'Designing with Adobe Illustrator',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=1',
      user: 'Jane Austen',
      status: 'Open',
      priority: 'Medium',
      open: true,
      createdAt: '2026-04-09T10:12:00Z'
    },
    {
      id: '#21234',
      subject: 'Creating Stunning Logos',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=2',
      user: 'J.K. Rowling',
      status: 'Open',
      priority: 'High',
      open: true,
      createdAt: '2026-02-28T08:45:00Z'
    },
    {
      id: '#39678',
      subject: 'Python Programming Essentials',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=3',
      user: 'Emily Brontë',
      status: 'Open',
      priority: 'High',
      open: true,
      createdAt: '2026-01-08T18:30:00Z'
    },
    {
      id: '#71789',
      subject: 'Effective Social Media Marketing',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=4',
      user: 'George Orwell',
      status: 'Resolved',
      priority: 'High',
      open: true,
      createdAt: '2026-03-07T14:05:00Z'
    },
    {
      id: '#36890',
      subject: 'Effective Email Marketing Campaigns',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=5',
      user: 'Fyodor Dostoevsky',
      status: 'Open',
      priority: 'Medium',
      open: true,
      createdAt: '2026-09-29T09:20:00Z'
    },
    {
      id: '#46890',
      subject: 'Animation Basics with After Effects',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=6',
      user: 'Harper Lee',
      status: 'In Progress',
      priority: 'Medium',
      open: true,
      createdAt: '2026-07-28T10:20:00Z'
    },
    {
      id: '#69678',
      subject: 'SEO Strategies for Business Growth',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=7',
      user: 'Charlotte Brontë',
      status: 'Failed',
      priority: 'High',
      open: true,
      createdAt: '2026-11-20T10:20:00Z'
    },
    {
      id: '#28901',
      subject: 'Creating Engaging Content',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=8',
      user: 'Herman Melville',
      status: 'Resolved',
      priority: 'Medium',
      open: true,
      createdAt: '2026-10-19T10:20:00Z'
    },
    {
      id: '#27890',
      subject: 'Professional Video Production',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=9',
      user: 'Fyodor Dostoevsky',
      status: 'In Progress',
      priority: 'High',
      open: true,
      createdAt: '2026-01-26T10:20:00Z'
    },
    {
      id: '#45678',
      subject: 'Designing Accessible Websites',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=10',
      user: 'Charles Dickens',
      status: 'Open',
      priority: 'Medium',
      open: true,
      createdAt: '2026-09-16T10:20:00Z'
    },
    {
      id: '#23567',
      subject: 'Motion Graphics with Cinema 4D',
      assignee: 'Olivia Rhye',
      avatar: 'https://i.pravatar.cc/32?img=11',
      user: 'Homer',
      status: 'Resolved',
      priority: 'High',
      open: false,
      createdAt: '2026-05-03T10:20:00Z'
    }
  ]);

  searchTerm = '';

  readonly activeTab = signal<'All' | 'Open' | 'In Progress' | 'Resolved' | 'Unassigned'>('All');

  readonly filteredTickets = computed(() => {
    const tab = this.activeTab();
    return this.tickets().filter((t) => {
      if (tab === 'Unassigned') return !t.assignee;
      if (tab !== 'All' && t.status !== tab) return false;
      return true;
    });
  });

  countStatus(status: Ticket['status']) {
    return this.tickets().filter((t) => t.status === status).length;
  }

  overdueCount() {
    return 0; 
  }

  unassignedCount() {
    return this.tickets().filter((t) => !t.assignee).length;
  }

  readonly sortDir = signal<'asc' | 'desc'>('desc');

  readonly displayTickets = computed(() => {
    const dir = this.sortDir();
    return [...this.filteredTickets()].sort((a, b) => {
      const aTime = new Date(a.createdAt).getTime();
      const bTime = new Date(b.createdAt).getTime();
      return dir === 'asc' ? aTime - bTime : bTime - aTime;
    });
  });

  toggleSort() {
    this.sortDir.set(this.sortDir() === 'asc' ? 'desc' : 'asc');
  }

  priorityBadgeClass(priority: Priority) {
    switch (priority) {
      case 'High':
            return 'bg-emerald-500/15 text-emerald-100 border border-emerald-400/50';
      case 'Medium':
            return 'bg-sky-500/15 text-sky-100 border border-sky-400/50';
      case 'Low':
            return 'bg-slate-500/15 text-slate-100 border border-slate-400/40';
    }
  }

      statusBadgeClass(status: Ticket['status']) {
        switch (status) {
          case 'Open':
            return 'bg-sky-500/15 text-sky-100 border border-sky-400/40';
          case 'In Progress':
            return 'bg-amber-500/15 text-amber-100 border border-amber-400/40';
          case 'Resolved':
            return 'bg-emerald-500/15 text-emerald-100 border border-emerald-400/40';
          case 'Failed':
            return 'bg-rose-500/15 text-rose-100 border border-rose-400/40';
        }
      }

  priorityDotClass(priority: Priority) {
    switch (priority) {
      case 'High':
        return 'bg-emerald-400';
      case 'Medium':
        return 'bg-sky-400';
      case 'Low':
        return 'bg-slate-400';
    }
  }
}

